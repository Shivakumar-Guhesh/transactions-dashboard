import datetime
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
from ..database import get_db
from ..db_utils import distinct_values, summarized_transactions, total_amount

router = APIRouter(tags=["Transaction Data"])

filters: Dict[str, list[str]] = dict()

filters["categories_to_skip_all_transactions"] = []
filters["categories_to_skip_expense"] = []
filters["categories_to_skip_income"] = []


@router.post("/data")
def get_data(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
    limit: int = 100,
    page=1,
):
    """POST endpoint for getting all transactions

    Returns:
        result: Transactions
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")

    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
    filters = [
        models.TransactionFact.category.notin_(exclude_expenses),
        models.TransactionFact.category.notin_(exclude_incomes),
    ]

    if start_date is not None:
        filters.append(models.TransactionFact.transaction_date >= start_date)
    if end_date is not None:
        filters.append(models.TransactionFact.transaction_date <= end_date)

    data = (
        db.execute(
            select(models.TransactionFact)
            .where(
                and_(
                    *filters,
                )
            )
            .limit(limit),
        )
        .scalars()
        .all()
    )

    return data


@router.get("/expense_categories")
def get_expense_categories(
    db: Session = Depends(get_db),
):
    """Get endpoint for getting all expense categories

    Returns:
        result: expense categories
    """
    # expense_categories = (
    #     db.execute(
    #         select(func.distinct(models.TransactionFact.category)).where(
    #             models.TransactionFact.transaction_type == "Expense"
    #         )
    #     )
    #     .scalars()
    #     .all()
    # )
    expense_categories = distinct_values(
        db=db,
        column=models.TransactionFact.category,
        filter_column=models.TransactionFact.transaction_type,
        filter_value="Expense",
    )
    return expense_categories


@router.get("/income_categories")
def get_income_categories(
    db: Session = Depends(get_db),
):
    """Get endpoint for getting all income categories

    Returns:
        result: income categories
    """
    # expense_categories = (
    #     db.execute(
    #         select(func.distinct(models.TransactionFact.category)).where(
    #             models.TransactionFact.transaction_type == "Expense"
    #         )
    #     )
    #     .scalars()
    #     .all()
    # )
    expense_categories = distinct_values(
        db=db,
        column=models.TransactionFact.category,
        filter_column=models.TransactionFact.transaction_type,
        filter_value="Income",
    )
    return expense_categories


@router.post("/total_expense")
def get_total_expense(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting total expense

    Returns:
        result: sum of all expenses
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
    try:
        total_expense = total_amount(
            db=db,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return total_expense


@router.post("/total_income")
def get_total_income(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting total income

    Returns:
        result: sum of all incomes
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")

    try:
        total_income = total_amount(
            db=db,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return total_income


@router.post("/liquid_asset_worth")
def get_liquid_asset_worth(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting Total asset worth

    Returns:
        result: Total asset by category
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")

    try:
        bought_assets = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            include_categories=liquid_assets_categories,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )
        sold_assets = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            include_categories=liquid_assets_categories,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )

        results_dict = {}
        for asset in bought_assets:
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


@router.post("/total_asset_worth")
def get_total_asset_worth(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting Total asset worth

    Returns:
        result: Total asset by category
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")

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
            start_date=start_date,
            end_date=end_date,
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
            start_date=start_date,
            end_date=end_date,
        )

        results_dict = {}
        for asset in bought_assets:
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


@router.post("/cat_expense_sum")
def get_cat_expense_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint category-wise summarized expenses

    Returns:
        result: category-wise summarized expenses
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
    try:
        cat_expense_sum = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return cat_expense_sum


@router.post("/cat_income_sum")
def get_cat_income_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting category-wise summarized incomes

    Returns:
        result: category-wise summarized incomes
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
    try:
        cat_income_sum = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return cat_income_sum


@router.post("/month_expense_sum")
def get_month_expense_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting month-wise summarized expenses

    Returns:
        result: month-wise summarized expenses
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
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
            start_date=start_date,
            end_date=end_date,
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return month_expense_sum


@router.post("/month_income_sum")
def get_month_income_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting month-wise summarized incomes

    Returns:
        result: month-wise summarized incomes
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
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
            start_date=start_date,
            end_date=end_date,
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return month_income_sum


@router.post("/mode_expense_sum")
def get_mode_expense_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint mode-wise summarized expenses

    Returns:
        result: mode-wise summarized expenses
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
    try:
        mode_expense_sum = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.transaction_mode,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return mode_expense_sum


@router.post("/mode_income_sum")
def get_mode_income_sum(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting mode-wise summarized incomes

    Returns:
        result: mode-wise summarized incomes
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
    try:
        mode_income_sum = summarized_transactions(
            db=db,
            groupby_column=models.TransactionFact.transaction_mode,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return mode_income_sum


@router.post("/monthly_balance")
def get_monthly_balance(
    body: schemas.TransactionsFiltersIn,
    db: Session = Depends(get_db),
):
    """POST endpoint for getting balance at the end of each month

    Returns:
        result: Balance at the end of each month
    """
    exclude_expenses = body.exclude_expenses
    exclude_incomes = body.exclude_incomes
    start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
    end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
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
            start_date=start_date,
            end_date=end_date,
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
            start_date=start_date,
            end_date=end_date,
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
        # result = [{month: balance} for month, balance in zip(months, balances)]
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
