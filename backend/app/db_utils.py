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
    filter_value: str | None = None,
    filter_column: InstrumentedAttribute | None = None,
) -> list[Row]:

    select_query = select(groupby_column, func.sum(aggregate_column))
    filters = [
        models.TransactionFact.category.notin_(exclude_expenses),
        models.TransactionFact.category.notin_(exclude_incomes),
    ]
    if filter_value is not None:
        filters.append(filter_column == filter_value)

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
):
    return db.execute(
        select(func.sum(aggregate_column)).where(
            and_(
                models.TransactionFact.category.notin_(exclude_expenses),
                models.TransactionFact.category.notin_(exclude_incomes),
                filter_column == filter_value,
            )
        )
    ).scalar_one()
