import json
from typing import List, Literal, Union

from pydantic import BaseModel, Field


class RouteQuery(BaseModel):
    destination: Literal["TABLE_SEARCH", "SEMANTIC_SEARCH"] = Field(
        description="The chain to route the query to. Must be 'TABLE_SEARCH' for aggregation/calculation ('TABLE_SEARCH') for totals, averages, or specific counts, or semantic lookup ('SEMANTIC_SEARCH') for explanations, contextual data, or general information. Respond with only a JSON object.",
    )

    @classmethod
    def get_schema_json(cls) -> str:
        return (
            json.dumps(cls.model_json_schema(), indent=2)
            .replace("{", "{{")
            .replace("}", "}}")
        )


class AskAIRequest(BaseModel):
    question: str


class AskAIResponse(BaseModel):
    answer: str


class SimpleFilter(BaseModel):
    """A single, atomic filter condition for a metadata field."""

    field: str = Field(
        description="The metadata field name (e.g., 'category', 'amount')."
    )
    operator: Literal["$eq", "$ne", "$gt", "$gte", "$lt", "$lte"] = Field(
        description="The ChromaDB operator ($eq, $ne, $gt, $gte, $lt, $lte)."
    )
    value: Union[str, float, int] = Field(
        description="The value to filter against. Must match the field's type (string, float, or integer)."
    )


class FilterList(BaseModel):
    """A list of atomic filter conditions to be combined with an AND operator."""

    filters: List[SimpleFilter] = Field(
        description="A list of one or more single-field, single-operator filter objects."
    )
