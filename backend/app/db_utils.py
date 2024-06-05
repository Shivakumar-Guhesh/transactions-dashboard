import datetime
from pickle import NONE

from sqlalchemy import and_, func, select
from sqlalchemy.engine.row import Row
from sqlalchemy.orm import Session
from sqlalchemy.orm.attributes import InstrumentedAttribute

from . import models


def summarized_transactions(
    db: Session,
    groupby_column: InstrumentedAttribute,
    aggregate_column: InstrumentedAttribute,
    exclude_expenses: list[str],
    exclude_incomes: list[str],
    include_categories: list[str] | None = None,
    filter_value: str | None = None,
    filter_column: InstrumentedAttribute | None = None,
    start_date: datetime.datetime | None = None,
    end_date: datetime.datetime | None = None,
) -> list[Row]:

    select_query = select(groupby_column, func.sum(aggregate_column))
    filters = [
        models.TransactionFact.category.notin_(exclude_expenses),
        models.TransactionFact.category.notin_(exclude_incomes),
    ]

    if filter_value is not None:
        filters.append(filter_column == filter_value)
    if include_categories is not None:
        filters.append(models.TransactionFact.category.in_(include_categories))

    if start_date is not None:
        filters.append(models.TransactionFact.transaction_date >= start_date)
    if end_date is not None:
        filters.append(models.TransactionFact.transaction_date <= end_date)

    return db.execute(
        select_query.where(
            and_(
                *filters,
            )
        ).group_by(groupby_column)
    ).all()


def total_amount(
    db: Session,
    aggregate_column: InstrumentedAttribute,
    exclude_expenses: list[str],
    exclude_incomes: list[str],
    filter_value: str,
    filter_column: InstrumentedAttribute,
    start_date: datetime.datetime | None = None,
    end_date: datetime.datetime | None = None,
):

    filters = [
        models.TransactionFact.category.notin_(exclude_expenses),
        models.TransactionFact.category.notin_(exclude_incomes),
        filter_column == filter_value,
    ]

    if start_date is not None:
        filters.append(models.TransactionFact.transaction_date >= start_date)
    if end_date is not None:
        filters.append(models.TransactionFact.transaction_date <= end_date)

    return db.execute(
        select(func.sum(aggregate_column)).where(
            and_(
                *filters,
            )
        )
    ).scalar_one()
