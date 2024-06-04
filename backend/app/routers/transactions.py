from typing import Dict

# import pandas as pd
from app import utils
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import and_, func, select, text
from sqlalchemy.engine.row import Row
from sqlalchemy.orm import Session
from sqlalchemy.orm.exc import NoResultFound

from .. import models, schemas
from ..constants import *

# from ..constants import INPUT_FILE
from ..database import get_db
from ..db_utils import summarized_transactions, total_amount

router = APIRouter(tags=["Transaction Data"])

# data = pd.read_excel(INPUT_FILE)


# data["Month"] = utils.add_period(data=data, col="Date")

# data["Date"] = pd.to_datetime(data["Date"])

filters: Dict[str, list[str]] = dict()

filters["categories_to_skip_all_transactions"] = []
filters["categories_to_skip_expense"] = []
filters["categories_to_skip_income"] = []


@router.get("/data")
def get_data(
    limit: int = 100,
    page=1,
    db: Session = Depends(get_db),
):

    data = db.execute(select(models.TransactionFact).limit(limit)).scalars().all()

    return data


@router.get("/total_expense")
def get_total_expense(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint for total expense

    Returns:
        result: sum of all expenses
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        total_expense = total_amount(
            db=db,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )

    return total_expense


@router.get("/total_income")
def get_total_income(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint for total income

    Returns:
        result: sum of all incomes
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        total_income = total_amount(
            db=db,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return total_income


@router.get("/net_worth")
def get_net_worth(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        bought_assets = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            include_categories=assets_categories,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
        )
        sold_assets = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            include_categories=assets_categories,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
        )

        results_dict = {}
        for asset in bought_assets:
            print("asset[0]: ", asset[0], "asset[1]: ", asset[1])
            if asset[0] in results_dict:
                results_dict[asset[0]] = results_dict[asset[0]] + asset[1]
            else:
                results_dict[asset[0]] = asset[1]
        for asset in sold_assets:
            if asset[0] in results_dict:
                results_dict[asset[0]] = results_dict[asset[0]] - asset[1]
            else:
                results_dict[asset[0]] = asset[1]

        return results_dict
    except NoResultFound:
        pass
    pass


@router.get("/cat_expense_sum")
def get_cat_expense_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint category-wise summarized expenses

    Returns:
        result: category-wise summarized expenses
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        cat_expense_sum = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return cat_expense_sum


@router.get("/cat_income_sum")
def get_cat_income_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint for category-wise summarized incomes

    Returns:
        result: category-wise summarized incomes
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        cat_income_sum = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return cat_income_sum


@router.get("/month_expense_sum")
def get_month_expense_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint for month-wise summarized expenses

    Returns:
        result: month-wise summarized expenses
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        month_expense_sum = summarized_transactions(
            db=db,
            groupby_column=func.strftime(
                "%Y-%m", models.TransactionFact.transaction_date
            ).label("Month"),
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return month_expense_sum


@router.get("/month_income_sum")
def get_month_income_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint for month-wise summarized incomes

    Returns:
        result: month-wise summarized incomes
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        month_income_sum = summarized_transactions(
            db=db,
            groupby_column=func.strftime(
                "%Y-%m", models.TransactionFact.transaction_date
            ).label("Month"),
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return month_income_sum


@router.get("/mode_expense_sum")
def get_mode_expense_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint mode-wise summarized expenses

    Returns:
        result: mode-wise summarized expenses
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        mode_expense_sum = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.transaction_mode,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return mode_expense_sum


@router.get("/mode_income_sum")
def get_mode_income_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint for mode-wise summarized incomes

    Returns:
        result: mode-wise summarized incomes
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        mode_income_sum = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.transaction_mode,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return mode_income_sum


@router.get("/monthly_balance")
def get_monthly_balance(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """GET endpoint for balance at the end of each month

    Returns:
        result: Balance at the end of each month
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    try:
        month_income_sum = summarized_transactions(
            db=db,
            groupby_column=func.strftime(
                "%Y-%m", models.TransactionFact.transaction_date
            ).label("Month"),
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
        )
        month_expense_sum = summarized_transactions(
            db=db,
            groupby_column=func.strftime(
                "%Y-%m", models.TransactionFact.transaction_date
            ).label("Month"),
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
        )
        len1 = len(month_expense_sum)
        len2 = len(month_income_sum)
        month_expenses = [elem[1] for elem in month_expense_sum]
        month_incomes = [elem[1] for elem in month_income_sum]
        max_len: int
        months: list[str]
        balances: list[int]
        if len1 > len2:
            max_len = len1
            months = [elem[0] for elem in month_expense_sum]
        else:
            max_len = len2
            months = [elem[0] for elem in month_income_sum]
        balances = [0] * len(months)
        if len1 < max_len:
            month_expenses += [0] * (max_len - len1)
        elif len2 < max_len:
            month_incomes += [0] * (max_len - len2)
        balances[0] = month_incomes[0] - month_expenses[0]
        for i in range(1, len(months)):
            balances[i] = balances[i - 1] + month_incomes[i] - month_expenses[i]
        result = [
            {"Month": month, "Balance": balance}
            for month, balance in zip(months, balances)
        ]
        return result
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )


@router.post("/filters", status_code=status.HTTP_201_CREATED)
def post_create_filters(payload: schemas.FilterPayload):
    """POST endpoint for adding filters
    Sample request:
        {
            "filter": "categories_to_skip_all_transactions",
            "categories": [
                "Lending"
            ]
        }
    Parameters:
        payload: payload of type FilterPayload

    Returns:
        <variable>: Description of the return value

    """
    filters[payload.filter] = payload.categories
    print(filters)
    utils.dump_json("./filters.json", filters)
    return f"Added {payload.categories} to filter {payload.filter}"
