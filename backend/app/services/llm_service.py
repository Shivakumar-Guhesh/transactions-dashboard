import datetime
import json
from typing import Any, Dict, List

from langchain_core.prompts import ChatPromptTemplate
from langchain_ollama import OllamaLLM
from pydantic import ValidationError

from .. import models
from ..repositories.llm_repository import LlmRepository
from ..repositories.transaction_repository import TransactionRepository
from ..schemas.llm_schemas import FilterList, RouteQuery, SimpleFilter
from .nlp_service import NlpService


class LlmService:
    """Handles business logic related to LLM chat and routing."""

    ROUTING_LLM_MODEL = "phi3:mini"
    SQL_GENERATION_LLM_MODEL = "deepseek-coder:6.7b-instruct-q4_K_M"
    FILTER_GENERATION_LLM_MODEL = "deepseek-coder:6.7b-instruct-q4_K_M"
    RAG_ANSWER_LLM_MODEL = "llama3.2:3b"

    routing_llm = OllamaLLM(model=ROUTING_LLM_MODEL, temperature=0.0, format="json")
    sql_generation_llm = OllamaLLM(model=SQL_GENERATION_LLM_MODEL, temperature=0.0)
    filter_generation_llm = OllamaLLM(
        model=FILTER_GENERATION_LLM_MODEL, temperature=0.0, format="json"
    )
    rag_answer_llm = OllamaLLM(model=RAG_ANSWER_LLM_MODEL)

    def __init__(
        self,
        transaction_repository: TransactionRepository,
        llm_repository: LlmRepository,
    ) -> None:
        self.transaction_repository = transaction_repository
        self.llm_repository = llm_repository

        self.distinct_categorical_values = self._get_categorical_values()
        self.nlp_service = NlpService(
            list(
                {
                    val
                    for values in self.distinct_categorical_values.values()
                    for val in values
                }
            )
        )

    def _get_categorical_values(self) -> Dict[str, List[str]]:
        columns = [
            models.TransactionFact.category,
            models.TransactionFact.transaction_type,
            models.TransactionFact.transaction_mode,
        ]
        return {
            col.key: list(
                {
                    val.lower()
                    for val in self.transaction_repository.distinct_values(
                        col, filter_value=None, filter_column=None
                    )
                    if val
                }
            )
            for col in columns
        }

    def convert_question(self, question: str) -> str:
        """Delegates query conversion to the NlpService."""
        return self.nlp_service.convert_question(question)

    def create_sql_query(self, question: str) -> str:

        tables_to_expose = ["TRANSACTION_FACT", "USER_ACCOUNT"]
        sql_prompt = ChatPromptTemplate.from_messages(
            [
                (
                    "system",
                    "EXPERT SQLite SQL DEVELOPER for PFA. TASK: Output a single, correct SQL query for the QUESTION.\n"
                    "**CRITICAL OUTPUT: ONLY RAW SQL QUERY. NO COMMENTS, NO MARKDOWN (NO ```).**\n"
                    "SCHEMA:\n"
                    "{table_info}\n"
                    "CATEGORICAL CONTEXT (LOWERCASE, STRICTLY USE ONLY THESE VALUES):\n"
                    "Format: 'Col: val1, val2, ...'\n"
                    "{distinct_values}\n"
                    "RULES:\n"
                    "1. **Aliases:** T1=TRANSACTION_FACT, T2=USER_ACCOUNT. Use aliases **ALWAYS**.\n"
                    "2. **Dates:** T1.TRANSACTION_DATE is 'YYYY-MM-DD'. Use `strftime('%Y-%m', date)` for month/year. Use `strftime('%Y', date)` for year. Use `T1.AMOUNT` for numeric calculations.\n"
                    "3. **Case:** Categorical columns (CATEGORY, ROLE, etc.) MUST use `LOWER(column) = 'value'`.\n"
                    "4. **Averages:** For queries involving 'average' or 'above average', **YOU MUST** use a Common Table Expression (CTE) or a subquery to calculate the average first, and then filter/select using that result.\n"
                    "5. **Joins:** ONLY join T1 to T2 on T1.USER_ID = T2.USER_ID IF filtering by T2 data (e.g., ROLE).\n"
                    "6. **Type/Safety:** DO NOT quote numerical values (AMOUNT, ID). Output ONE statement (NO ';', NO dynamic SQL).\n"
                    "7. **Implicit Filters:** 'Spending/Cost/Purchases' MUST include `LOWER(T1.TRANSACTION_TYPE) = 'expense'`. 'Income/Salary/Earnings' MUST include `LOWER(T1.TRANSACTION_TYPE) = 'income'`.\n",
                ),
                ("human", "question: {question}"),
            ]
        )
        table_info: str = ""
        for table_name in tables_to_expose:
            table_info = (
                table_info
                + "\n\n"
                + self.transaction_repository.get_table_schema(table_name)
            )

        prompt = sql_prompt.partial(
            table_info=table_info,
            distinct_values="\n".join(
                [
                    f"Available {k} values: {', '.join(v)}"
                    for k, v in self.distinct_categorical_values.items()
                ]
            ),
        )
        llm_output = self.sql_generation_llm.invoke(
            prompt.invoke({"question": question})
        )
        return llm_output

    def fetch_sql_records(self, query: str) -> str:
        result = self.transaction_repository.execute_raw_select(query)
        cols = list(result.keys())
        rows = result.fetchall()
        header = f"| {' | '.join(cols)} |"
        sep = f"| {' | '.join(['---'] * len(cols))} |"
        body = [f"| {' | '.join(map(str, row))} |" for row in rows]
        return "\n".join([header, sep] + body)

    def create_metadata_filter(
        self, question: str, distinct_values: str
    ) -> Dict[str, Any]:
        metadata_schema = {
            "transaction_timestamp": "float (Unix timestamp). DO NOT USE THIS FIELD for time filtering.",
            "category": "Specific spending category like 'food', 'rent', etc. NEVER 'expense' or 'income'.",
            "amount": "float",
            "transaction_type": "MUST BE either 'expense' or 'income'.",
            "currency": "string (e.g., 'usd', 'eur')",
            "year": "integer",
            "month": "integer (1-12)",
            "day": "integer (1-31)",
        }

        now = datetime.datetime.now()
        current_date_context = (
            f"Current Date: {now.strftime('%Y-%m-%d')}. "
            f"Current Year: {now.year}, Current Month: {now.month} (1-12), Current Day: {now.day}. "
            f"**STRICTLY DO NOT USE 'transaction_timestamp'.** Instead, use the 'year', 'month', and 'day' integer fields with comparison operators ($eq, $gte, $lte) to define the time range."
        )

        llm_output_schema = str(FilterList.model_json_schema())

        filter_prompt = ChatPromptTemplate.from_messages(
            [
                (
                    "system",
                    "You are an expert financial analysis tool that converts a user's request into a valid ChromaDB metadata filter JSON object.\n"
                    "Your output MUST strictly match the 'FilterList' Pydantic schema.\n\n"
                    "**METADATA FIELDS:**\n"
                    f"""{{metadata_schema}}\n\n"""
                    "**CRITICAL CATEGORICAL CONTEXT (STRICTLY ADHERE TO THESE VALUES):**\n"
                    f"Format: 'Col: val1, val2, ...'\n{{distinct_values}}\n\n"
                    "**CRITICAL TEMPORAL CONTEXT:**\n"
                    f"{{current_date_context}}\n\n"
                    "**RULES:**\n"
                    "1. **Output Format:** You MUST produce a single JSON object matching the 'FilterList' schema.\n"
                    "2. **Atomic Filters:** Each condition must be a separate SimpleFilter object in the 'filters' list.\n"
                    "3. **CRITICAL TIME RULE:** For ALL time-based ranges (e.g., 'last month', 'this year'), you MUST ONLY use the discrete integer fields: 'year', 'month', and 'day'. Create separate filter conditions for each relevant field using appropriate operators ($eq, $gte, $lte). **NEVER use 'transaction_timestamp'**.\n"
                    "4. **Categorical Strings:** For string fields, you MUST use **$eq** and the 'value' MUST be **lowercase** and an **exact match** from the CRITICAL CATEGORICAL CONTEXT list.\n"
                    "5. **Numeric Comparisons:** For $gt, $gte, $lt, $lte, the 'value' MUST be a concrete number (float or integer). Use a sensible default (e.g., 500) if no number is provided (e.g., 'large amount').\n"
                    '6. **Fallback:** If no filter can be extracted, return: {{"filters": []}}',
                ),
                ("human", "USER QUESTION: {question}"),
            ]
        )

        prompt = filter_prompt.partial(
            llm_output_schema=llm_output_schema,
        )

        llm_output = self.filter_generation_llm.invoke(
            prompt.invoke(
                {
                    "question": question,
                    "current_date_context": current_date_context,
                    "distinct_values": distinct_values,
                    "metadata_schema": json.dumps(metadata_schema, indent=2),
                }
            )
        )

        try:
            filters = json.loads(llm_output)
        except json.JSONDecodeError:
            return {}

        if not filters:
            return {}

        simple_filters = filters.get("filters", [])
        validated_filters = []
        comparison_operators = {"$gt", "$gte", "$lt", "$lte"}

        for item in simple_filters:
            try:
                filter_obj = SimpleFilter(**item)
            except ValidationError as e:

                continue

            key = filter_obj.field
            operator = filter_obj.operator
            value = filter_obj.value

            if key == "category" and value in ["expense", "income"]:
                key = "transaction_type"

            if operator in comparison_operators:
                if value is None or not isinstance(value, (int, float)):

                    continue

            validated_filters.append({"key": key, "operator": operator, "value": value})

        if not validated_filters:
            return {}

        chroma_conditions = []
        for item in validated_filters:
            chroma_conditions.append({item["key"]: {item["operator"]: item["value"]}})

        if len(chroma_conditions) == 1:
            return chroma_conditions[0]
        else:
            return {"$and": chroma_conditions}

    def semantic_retrieval(self, question: str, filters: dict):

        results = self.llm_repository.semantic_search(
            question=question, filters=filters
        )
        return results

    def route_user_question(self, question: str) -> str:
        question = self.convert_question(question)
        TABLE_SEARCH_KEYWORDS = {
            "amount",
            "average",
            "count",
            "earn",
            "figure",
            "max",
            "min",
            "number",
            "pay",
            "spend",
            "sum",
            "total",
            "value",
        }
        SEMANTIC_SEARCH_KEYWORDS = {
            "analysis",
            "anomaly",
            "budget",
            "cause",
            "citation",
            "compare",
            "con",
            "context",
            "description",
            "detect",
            "explain",
            "flag",
            "meaning",
            "narrative",
            "pro",
            "reason",
            "recommendation",
            "similar",
            "strategy",
            "unusual",
        }

        lemmas = self.nlp_service.get_lemma(question)
        route = "UNKNOWN"

        for lemma in lemmas:
            if lemma in TABLE_SEARCH_KEYWORDS and lemma not in SEMANTIC_SEARCH_KEYWORDS:
                route = "TABLE_SEARCH"
            elif (
                lemma not in TABLE_SEARCH_KEYWORDS and lemma in SEMANTIC_SEARCH_KEYWORDS
            ):
                route = "SEMANTIC_SEARCH"

        if route == "UNKNOWN":
            routing_result = self.router_chain(question)
            route = routing_result.destination.upper()

        return route

    def router_chain(self, question: str) -> RouteQuery:
        router_prompt = ChatPromptTemplate.from_messages(
            [
                (
                    "system",
                    "You are a **Financial Query Router**. Your **sole task** is to classify the user's QUESTION into one of two output types: **TABLE_SEARCH** or **SEMANTIC_SEARCH**.\n\n"
                    "---"
                    "### **OUTPUT FORMAT INSTRUCTION**\n"
                    "You **MUST** respond with **ONLY** a single, **flat JSON object** that represents a valid instance of the 'RouteQuery' data structure. "
                    "DO NOT output the JSON schema definition, DO NOT include any 'properties', 'required', 'title', or 'description' keys. "
                    "The final object must strictly match the structure defined by this schema:\n"
                    f"""```json\n{RouteQuery.get_schema_json()}\n```\n""",
                ),
                ("human", "Query: {query}\n\n"),
            ]
        )
        llm_output = self.routing_llm.invoke(router_prompt.invoke({"query": question}))
        return RouteQuery.model_validate(json.loads(llm_output))

    def rag_answer_chain(self, question: str, route: str) -> str:
        if route == "TABLE_SEARCH":
            created_sql_query = self.create_sql_query(question)
            augmented_info = self.fetch_sql_records(created_sql_query)

            answer_prompt = ChatPromptTemplate.from_messages(
                [
                    (
                        "system",
                        "You are a polite and helpful Personal Financial Assistant (PFA). Your task is to provide a clear, concise, and accurate answer to the user's question based on the provided augmented_info.\n"
                        "\n"
                        "USER QUESTION: {question}\n"
                        "augmented_info: {augmented_info}\n"
                        "\n"
                        "INSTRUCTIONS:\n"
                        "1. **CRITICAL: DO NOT PERFORM ANY NEW CALCULATIONS OR SUMMARIES. The 'augmented_info' is the final, filtered set of data.** Your role is only to narrate or format this result for the user.\n"
                        "2. If the result is a single number (e.g., '[(1500.50,)]'), provide **only** that number (e.g., \"1500.50\").\n"
                        "3. If the result is a list/table, re-format the data clearly for the user (e.g., as a bulleted list or simple table). If the list is empty (e.g., '[]' or '[(None,)]'), state clearly that no data was found.\n"
                        "4. If the result contains 'None' or is empty, phrase the answer as \"No data was found for [original query context].\"\n"
                        "5. The currency for transaction is INR (₹)",
                    ),
                ]
            )
        else:
            filters = self.create_metadata_filter(
                question,
                distinct_values="\n".join(
                    [
                        f"Available {k} values: {', '.join(v)}"
                        for k, v in self.distinct_categorical_values.items()
                    ]
                ),
            )
            augmented_info = self.semantic_retrieval(question, filters)
            answer_prompt = ChatPromptTemplate.from_messages(
                [
                    (
                        "system",
                        "You are an Expert Personal Financial Assistant (PFA). Your task is to provide a comprehensive, analytical, and polite answer to the user's question.\n"
                        "**CRITICAL:** Base your answer **ONLY** on the provided context/documents. If the context does not contain the answer, state clearly that the necessary information could not be found.\n\n"
                        "USER QUESTION: {question}\n"
                        "augmented_info :\n"
                        "{augmented_info}\n\n"
                        "INSTRUCTIONS:\n"
                        "1. Synthesize the context into a single, well-structured narrative or analysis.\n"
                        "2. If the user asks for a summary or anomaly detection, perform it based on the documents.\n"
                        "3. Use a polite and helpful tone. The currency is INR (₹).",
                    ),
                ]
            )
        prompt = answer_prompt.partial()
        llm_output = self.rag_answer_llm.invoke(
            prompt.invoke({"question": question, "augmented_info": augmented_info})
        )
        return llm_output
