import datetime
from operator import or_

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

    filters = []
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
                models.TransactionFact.transaction_fact_id.not_in(
                    select(models.TransactionFact.transaction_fact_id).where(
                        or_(
                            and_(
                                models.TransactionFact.transaction_type == "Expense",
                                models.TransactionFact.category.in_(exclude_expenses),
                            ),
                            and_(
                                models.TransactionFact.transaction_type == "Income",
                                models.TransactionFact.category.in_(exclude_incomes),
                            ),
                        )
                    )
                ),
            )
        )
        .group_by(groupby_column)
        .order_by(groupby_column)
    ).all()


def distinct_values(
    db: Session,
    column: InstrumentedAttribute,
    filter_value: str,
    filter_column: InstrumentedAttribute,
):
    return (
        db.execute(
            select(func.distinct(column))
            .where(filter_column == filter_value)
            .order_by(column)
        )
        .scalars()
        .all()
    )


def total_amount(
    db: Session,
    exclude_expenses: list[str],
    exclude_incomes: list[str],
    filter_value: str,
    filter_column: InstrumentedAttribute,
    start_date: datetime.datetime | None = None,
    end_date: datetime.datetime | None = None,
):

    filters = []
    if start_date is not None:
        filters.append(models.TransactionFact.transaction_date >= start_date)
    if end_date is not None:
        filters.append(models.TransactionFact.transaction_date <= end_date)

    driving_source_exclude_list = []
    opposite_source_exclude_list = []

    if filter_value == "Expense":
        driving_source_exclude_list = exclude_expenses
        opposite_source_exclude_list = exclude_incomes

    else:
        driving_source_exclude_list = exclude_incomes
        opposite_source_exclude_list = exclude_expenses

    driving_source = (
        select(
            models.TransactionFact.category.label("category"),
            func.sum(models.TransactionFact.amount).label("total"),
        )
        .where(
            and_(
                *filters,
                filter_column == filter_value,
                models.TransactionFact.transaction_fact_id.not_in(
                    and_(
                        models.TransactionFact.transaction_type == filter_value,
                        models.TransactionFact.category.in_(
                            driving_source_exclude_list
                        ),
                    ),
                ),
            )
        )
        .group_by(models.TransactionFact.category)
    )

    opposite_source = (
        select(
            models.TransactionFact.category.label("category"),
            func.sum(models.TransactionFact.amount).label("total"),
        )
        .where(
            and_(
                *filters,
                filter_column != filter_value,
                models.TransactionFact.transaction_fact_id.not_in(
                    and_(
                        models.TransactionFact.transaction_type != filter_value,
                        models.TransactionFact.category.in_(
                            opposite_source_exclude_list
                        ),
                    ),
                ),
            )
        )
        .group_by(models.TransactionFact.category)
        .subquery()
    )

    # USE MAX ONLY FOR SQLITE, GREATEST FOR OTHER SQL
    category_wise_sum = (
        select(
            (
                func.max(
                    driving_source.c.total - func.coalesce(opposite_source.c.total, 0),
                    0,
                )
            ).label("net_total")
        )
        .select_from(driving_source)
        .join(
            opposite_source,
            driving_source.c.category == opposite_source.c.category,
            isouter=True,
        )
    )

    return db.execute(select(func.sum(category_wise_sum.c.net_total))).scalar_one()

    # return db.execute(
    #     select(func.sum(models.TransactionFact.amount)).where(
    #         and_(
    #             *filters,
    #             filter_column == filter_value,
    #             models.TransactionFact.transaction_fact_id.not_in(
    #                 select(models.TransactionFact.transaction_fact_id).where(
    #                     or_(
    #                         and_(
    #                             models.TransactionFact.transaction_type == "Expense",
    #                             models.TransactionFact.category.in_(exclude_expenses),
    #                         ),
    #                         and_(
    #                             models.TransactionFact.transaction_type == "Income",
    #                             models.TransactionFact.category.in_(exclude_incomes),
    #                         ),
    #                     )
    #                 )
    #             ),
    #         )
    #     )
    # ).scalar_one()
