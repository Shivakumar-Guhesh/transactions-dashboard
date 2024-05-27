from typing import Dict

import pandas as pd
from app import utils
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import and_, func, select
from sqlalchemy.orm import Session
from sqlalchemy.orm.exc import NoResultFound

from .. import models, schemas
from ..constants import INPUT_FILE
from ..database import get_db

router = APIRouter(tags=["Transaction Data"])

data = pd.read_excel(INPUT_FILE)


data["Month"] = utils.add_period(data=data, col="Date")

data["Date"] = pd.to_datetime(data["Date"])

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


@router.get("/cat_expense_sum")
def get_cat_expense_sum(
    body: schemas.CatSumIn,
    db: Session = Depends(get_db),
):
    """GET endpoint for cat_expense_sum.
    Returns category-wise summarized expenses

    Returns:
        result: category-wise summarized expenses
    """
    exclude_expenses = body.exclude_expenses
    try:
        cat_expense_sum = db.execute(
            select(
                models.TransactionFact.category,
                func.sum(models.TransactionFact.amount),
            )
            .where(
                and_(
                    models.TransactionFact.category.notin_(exclude_expenses),
                    models.TransactionFact.transaction_type == "Expense",
                )
            )
            .group_by(models.TransactionFact.category)
        ).all()
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"No records found"
        )
    return cat_expense_sum


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
