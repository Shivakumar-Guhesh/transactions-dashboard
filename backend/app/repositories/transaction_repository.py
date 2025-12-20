import datetime
from operator import or_

from sqlalchemy import MetaData, String, Table, and_, func, select
from sqlalchemy.engine import Result
from sqlalchemy.engine.row import Row
from sqlalchemy.orm import Session
from sqlalchemy.orm.attributes import InstrumentedAttribute
from sqlalchemy.schema import CreateTable
from sqlalchemy.sql import text
from sqlalchemy.types import DECIMAL

from .. import models


class TransactionRepository:
    """Handles database operations related to transactions data.

    Args:
        db (Session): SQLAlchemy Session object.
    """

    def __init__(self, db: Session) -> None:
        self.db = db

    def __add_date_filter(
        self,
        start_date: datetime.datetime | None = None,
        end_date: datetime.datetime | None = None,
    ) -> list:
        filters = []
        if start_date is not None:
            filters.append(models.TransactionFact.transaction_date >= start_date)
        if end_date is not None:
            filters.append(models.TransactionFact.transaction_date <= end_date)
        return filters

    def fetch_all_transactions(
        self,
        exclude_expenses: list[str],
        exclude_incomes: list[str],
        start_date: datetime.datetime | None = None,
        end_date: datetime.datetime | None = None,
        limit: int = 100,
        page=1,
    ) -> list[Row]:
        filters = self.__add_date_filter(start_date, end_date)
        if exclude_expenses:
            filters.append(~models.TransactionFact.category.in_(exclude_expenses))
        if exclude_incomes:
            filters.append(~models.TransactionFact.category.in_(exclude_incomes))

        offset = (page - 1) * limit if page and page > 0 else 0

        data = (
            self.db.execute(
                select(models.TransactionFact)
                .where(
                    and_(
                        *filters,
                    )
                )
                .limit(limit)
                .offset(offset),
            )
            .scalars()
            .all()
        )

        return data

    def distinct_values(
        self,
        column: InstrumentedAttribute,
        filter_value: str | None,
        filter_column: InstrumentedAttribute | None,
    ) -> list[String]:
        if filter_column is not None:
            return (
                self.db.execute(
                    select(func.distinct(column))
                    .where(filter_column == filter_value)
                    .order_by(column)
                )
                .scalars()
                .all()
            )
        else:
            return (
                self.db.execute(select(func.distinct(column)).order_by(column))
                .scalars()
                .all()
            )

    def summarized_transactions(
        self,
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

        filters = self.__add_date_filter(start_date, end_date)

        if filter_value is not None:
            filters.append(filter_column == filter_value)
        if include_categories is not None:
            filters.append(models.TransactionFact.category.in_(include_categories))

        return self.db.execute(
            select_query.where(
                and_(
                    *filters,
                    models.TransactionFact.transaction_fact_id.notin_(
                        select(models.TransactionFact.transaction_fact_id).where(
                            or_(
                                and_(
                                    models.TransactionFact.transaction_type
                                    == "Expense",
                                    models.TransactionFact.category.in_(
                                        exclude_expenses
                                    ),
                                ),
                                and_(
                                    models.TransactionFact.transaction_type == "Income",
                                    models.TransactionFact.category.in_(
                                        exclude_incomes
                                    ),
                                ),
                            )
                        )
                    ),
                )
            )
            .group_by(groupby_column)
            .order_by(groupby_column)
        ).all()

    def total_amount(
        self,
        exclude_expenses: list[str],
        exclude_incomes: list[str],
        filter_value: str,
        filter_column: InstrumentedAttribute,
        start_date: datetime.datetime | None = None,
        end_date: datetime.datetime | None = None,
    ) -> DECIMAL:

        filters = self.__add_date_filter(start_date, end_date)

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
                    models.TransactionFact.transaction_fact_id.notin_(
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
                    models.TransactionFact.transaction_fact_id.notin_(
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
                        driving_source.c.total
                        - func.coalesce(opposite_source.c.total, 0),
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

        return self.db.execute(
            select(func.sum(category_wise_sum.c.net_total))
        ).scalar_one()

    def execute_raw_select(self, sql_query: str) -> Result:
        """
        Executes a raw SQL SELECT query and returns the results as a list of dictionaries.

        """

        statement = text(sql_query)
        result = self.db.execute(statement)
        return result

    def get_table_schema(self, table_name: str) -> str:
        """Function to get schema of provided table as a string"""
        engine = self.db.get_bind()
        metadata = MetaData()
        metadata.reflect(bind=engine)
        table_info: str = ""
        with engine.connect() as connection:
            table = Table(table_name, metadata, autoload_with=engine)
            table_info = table_info + "\n\n" + str(CreateTable(table).compile(engine))
        return table_info
