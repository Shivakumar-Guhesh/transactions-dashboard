from fastapi import APIRouter, Depends

from ..dependencies import get_llm_service
from ..schemas.llm_schemas import AskAIRequest, AskAIResponse
from ..services.llm_service import LlmService

router = APIRouter(prefix="/llm", tags=["LLM"])


@router.post("/ask_ai", response_model=AskAIResponse)
def ask_ai(
    request: AskAIRequest, service: LlmService = Depends(get_llm_service)
) -> AskAIResponse:
    """POST endpoint for ask ai"""
    converted_question = service.convert_question(request.question)
    route = service.route_user_question(converted_question)
    # output = service.fetch_sql_records(lower_query)
    answer = service.rag_answer_chain(question=converted_question, route=route)
    return AskAIResponse.model_validate({"answer": answer})
