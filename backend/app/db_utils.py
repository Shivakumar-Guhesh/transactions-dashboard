from pickle import NONE

from sqlalchemy import and_, func, select
from sqlalchemy.orm import Session
from sqlalchemy.orm.attributes import InstrumentedAttribute
from sqlalchemy.orm.exc import NoResultFound

from . import models, schemas


def summarized_transactions(
    db: Session,
    groupby_column: InstrumentedAttribute,
    aggregate_column: InstrumentedAttribute,
    exclude_expenses: list[str],
    exclude_incomes: list[str],
    filter_value: str | None = None,
    filter_column: InstrumentedAttribute | None = None,
):
    if filter_value is None:
        return db.execute(
            select(
                groupby_column,
                func.sum(aggregate_column),
            )
            .where(
                and_(
                    models.TransactionFact.category.notin_(exclude_expenses),
                    models.TransactionFact.category.notin_(exclude_incomes),
                )
            )
            .group_by(models.TransactionFact.category)
        ).all()
    else:
        return db.execute(
            select(
                groupby_column,
                func.sum(aggregate_column),
            )
            .where(
                and_(
                    models.TransactionFact.category.notin_(exclude_expenses),
                    models.TransactionFact.category.notin_(exclude_incomes),
                    filter_column == filter_value,
                )
            )
            .group_by(models.TransactionFact.category)
        ).all()
