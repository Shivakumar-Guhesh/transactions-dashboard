# TODO: Remove all SQL related code.

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm.exc import NoResultFound

from ..dependencies import get_transaction_service
from ..schemas.transaction_schemas import (
    TransactionsDataResponse,
    TransactionsDistinctValuesListResponse,
    TransactionsFiltersRequest,
    TransactionsGroupAmountResponse,
    TransactionsTotalAmountResponse,
)
from ..services.transaction_service import TransactionService

router = APIRouter(prefix="/transactions", tags=["Transaction Data"])


@router.post("/data", response_model=list[TransactionsDataResponse])
def get_data(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
    limit: int = 100,
    page=1,
):
    """POST endpoint for getting all transactions

    Returns:
        result: Rows of transactions
        Response Body Schema: TransactionsDataResponse
    """
    return service.get_data(body, limit, page)


@router.get(
    "/expense_categories", response_model=TransactionsDistinctValuesListResponse
)
def get_expense_categories(
    service: TransactionService = Depends(get_transaction_service),
):
    """Get endpoint for getting all expense categories

    Returns:
        result: Expense categories
        Response Body Schema : TransactionsDistinctValuesListResponse
    """
    return service.get_expense_categories()


@router.get("/income_categories", response_model=TransactionsDistinctValuesListResponse)
def get_income_categories(
    service: TransactionService = Depends(get_transaction_service),
):
    """Get endpoint for getting all income categories

    Returns:
        result: Income categories
        Response Body Schema : TransactionsDistinctValuesListResponse
    """
    return service.get_income_categories()


@router.post("/total_expense", response_model=TransactionsTotalAmountResponse)
def get_total_expense(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting total expense

    Returns:
        result: sum of all expenses
        Response Body Schema : TransactionsTotalAmount
    """

    return service.get_total_expense(body)


@router.post("/total_income", response_model=TransactionsTotalAmountResponse)
def get_total_income(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting total income

    Returns:
        result: sum of all incomes
        Response Body Schema : TransactionsTotalAmount
    """

    return service.get_total_income(body)


@router.post("/liquid_asset_worth", response_model=TransactionsGroupAmountResponse)
def get_liquid_asset_worth(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting Total asset worth

    Returns:
        result: Total asset by category
    """

    return service.get_liquid_asset_worth(body)


@router.post("/total_asset_worth", response_model=TransactionsGroupAmountResponse)
def get_total_asset_worth(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting Total asset worth

    Returns:
        result: Total asset by category
    """
    return service.get_total_asset_worth(body)


@router.post("/cat_expense_sum", response_model=TransactionsGroupAmountResponse)
def get_cat_expense_sum(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint category-wise summarized expenses

    Returns:
        result: category-wise summarized expenses
    """
    return service.get_cat_expense_sum(body)


@router.post("/cat_income_sum", response_model=TransactionsGroupAmountResponse)
def get_cat_income_sum(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting category-wise summarized incomes

    Returns:
        result: category-wise summarized incomes
    """
    return service.get_cat_income_sum(body)


@router.post("/month_expense_sum", response_model=TransactionsGroupAmountResponse)
def get_month_expense_sum(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting month-wise summarized expenses

    Returns:
        result: month-wise summarized expenses
    """

    return service.get_month_expense_sum(body)


@router.post("/month_income_sum", response_model=TransactionsGroupAmountResponse)
def get_month_income_sum(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting month-wise summarized incomes

    Returns:
        result: month-wise summarized incomes
    """
    return service.get_month_income_sum(body)


@router.post("/mode_expense_sum", response_model=TransactionsGroupAmountResponse)
def get_mode_expense_sum(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint mode-wise summarized expenses

    Returns:
        result: mode-wise summarized expenses
    """
    return service.get_mode_expense_sum(body)


@router.post("/mode_income_sum", response_model=TransactionsGroupAmountResponse)
def get_mode_income_sum(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting mode-wise summarized incomes

    Returns:
        result: mode-wise summarized incomes
    """
    return service.get_mode_income_sum(body)


@router.post("/monthly_balance", response_model=TransactionsGroupAmountResponse)
def get_monthly_balance(
    body: TransactionsFiltersRequest,
    service: TransactionService = Depends(get_transaction_service),
):
    """POST endpoint for getting balance at the end of each month

    Returns:
        result: Balance at the end of each month
    """
    return service.get_monthly_balance(body)


# @router.post("/filters", status_code=status.HTTP_201_CREATED)
# def post_create_filters(payload: schemas.FilterPayload):
#     """POST endpoint for adding filters
#     Sample request:
#         {
#             "filter": "categories_to_skip_all_transactions",
#             "categories": [
#                 "Lending"
#             ]
#         }
#     Parameters:
#         payload: payload of type FilterPayload

#     Returns:
#         <variable>: Description of the return value

#     """
#     filters[payload.filter] = payload.categories
#     print(filters)
#     utils.dump_json("./filters.json", filters)
#     return f"Added {payload.categories} to filter {payload.filter}"
