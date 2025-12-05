import datetime

from sqlalchemy import func

from .. import models
from ..constants import asset_categories_list, liquid_assets_categories
from ..repositories.transaction_repository import TransactionRepository
from ..schemas.transaction_schemas import (
    TransactionsDataResponse,
    TransactionsDistinctValuesListResponse,
    TransactionsFiltersRequest,
    TransactionsGroupAmountResponse,
    TransactionsTotalAmountResponse,
)


class TransactionService:
    """Handles business logic related to transactions data.

    Args:
        repository (TransactionRepository): An instance of TransactionRepository.
    """

    def __init__(self, repository: TransactionRepository) -> None:
        self.repository = repository

    def _get_net_group_wise_total(
        self, driving_groups, opposing_groups=None, include_opposing_source=False
    ) -> dict:

        results_dict = {}
        for group in driving_groups:
            if group[0] in results_dict:
                results_dict[group[0]] = results_dict[group[0]] + group[1]
            else:
                results_dict[group[0]] = group[1]
        if opposing_groups is not None:
            for group in opposing_groups:
                if group[0] in results_dict:
                    results_dict[group[0]] = max(results_dict[group[0]] - group[1], 0)
                elif include_opposing_source:
                    results_dict[group[0]] = group[1]

        for key, value in list(results_dict.items()):
            if value == 0:
                del results_dict[key]

        return results_dict

    def _parse_request_body(self, body: TransactionsFiltersRequest):
        exclude_expenses = body.exclude_expenses
        exclude_incomes = body.exclude_incomes
        start_date = datetime.datetime.strptime(body.start_date, "%Y%m%d")
        end_date = datetime.datetime.strptime(body.end_date, "%Y%m%d")
        return exclude_expenses, exclude_incomes, start_date, end_date

    def get_data(
        self,
        body: TransactionsFiltersRequest,
        limit: int = 100,
        page=1,
    ) -> list[TransactionsDataResponse]:

        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        data = self.repository.fetch_all_transactions(
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            start_date=start_date,
            end_date=end_date,
            limit=limit,
            page=page,
        )
        return [TransactionsDataResponse.model_validate(item) for item in data]

    def get_expense_categories(
        self,
    ) -> TransactionsDistinctValuesListResponse:
        expense_categories = {
            "values": self.repository.distinct_values(
                column=models.TransactionFact.category,
                filter_column=models.TransactionFact.transaction_type,
                filter_value="Expense",
            )
        }
        model_data = TransactionsDistinctValuesListResponse.model_validate(
            expense_categories
        )
        return model_data

    def get_income_categories(
        self,
    ) -> TransactionsDistinctValuesListResponse:
        expense_categories = {
            "values": self.repository.distinct_values(
                column=models.TransactionFact.category,
                filter_column=models.TransactionFact.transaction_type,
                filter_value="Income",
            )
        }
        return TransactionsDistinctValuesListResponse.model_validate(expense_categories)

    def get_total_expense(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsTotalAmountResponse:
        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        total_expense = self.repository.total_amount(
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )
        return TransactionsTotalAmountResponse.model_validate({"total": total_expense})

    def get_total_income(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsTotalAmountResponse:
        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        total_income = self.repository.total_amount(
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )
        return TransactionsTotalAmountResponse.model_validate({"total": total_income})

    def get_liquid_asset_worth(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:

        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        bought_assets = self.repository.summarized_transactions(
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
        sold_assets = self.repository.summarized_transactions(
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

        results_dict = self._get_net_group_wise_total(
            bought_assets, sold_assets, include_opposing_source=True
        )

        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )

    def get_total_asset_worth(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:

        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        bought_assets = self.repository.summarized_transactions(
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            include_categories=asset_categories_list,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )
        sold_assets = self.repository.summarized_transactions(
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            include_categories=asset_categories_list,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )

        results_dict = self._get_net_group_wise_total(
            bought_assets, sold_assets, include_opposing_source=True
        )

        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )

    def get_cat_expense_sum(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:

        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        cat_expense_sum = self.repository.summarized_transactions(
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )
        cat_income_sum = self.repository.summarized_transactions(
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )

        results_dict = self._get_net_group_wise_total(cat_expense_sum, cat_income_sum)

        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )

    def get_cat_income_sum(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:

        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        cat_income_sum = self.repository.summarized_transactions(
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )
        cat_expense_sum = self.repository.summarized_transactions(
            groupby_column=models.TransactionFact.category,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )

        results_dict = self._get_net_group_wise_total(cat_income_sum, cat_expense_sum)

        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )

    def get_month_expense_sum(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:

        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        month_expense_sum = self.repository.summarized_transactions(
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

        results_dict = self._get_net_group_wise_total(month_expense_sum)
        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )

    def get_month_income_sum(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:

        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        month_income_sum = self.repository.summarized_transactions(
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

        results_dict = self._get_net_group_wise_total(month_income_sum)
        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )

    def get_mode_expense_sum(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:

        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        mode_expense_sum = self.repository.summarized_transactions(
            groupby_column=models.TransactionFact.transaction_mode,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Expense",
            start_date=start_date,
            end_date=end_date,
        )

        results_dict = self._get_net_group_wise_total(mode_expense_sum)
        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )

    def get_mode_income_sum(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:
        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        mode_income_sum = self.repository.summarized_transactions(
            groupby_column=models.TransactionFact.transaction_mode,
            aggregate_column=models.TransactionFact.amount,
            exclude_expenses=exclude_expenses,
            exclude_incomes=exclude_incomes,
            filter_column=models.TransactionFact.transaction_type,
            filter_value="Income",
            start_date=start_date,
            end_date=end_date,
        )

        results_dict = self._get_net_group_wise_total(mode_income_sum)
        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )

    def get_monthly_balance(
        self,
        body: TransactionsFiltersRequest,
    ) -> TransactionsGroupAmountResponse:
        (
            exclude_expenses,
            exclude_incomes,
            start_date,
            end_date,
        ) = self._parse_request_body(body)

        month_income_sum = self.repository.summarized_transactions(
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
        month_expense_sum = self.repository.summarized_transactions(
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

        results_dict = {}
        for month, balance in zip(months, balances):
            if month in results_dict:
                results_dict[month] = results_dict[month] + balance
            else:
                results_dict[month] = balance

        return TransactionsGroupAmountResponse.model_validate(
            {"group_amount": results_dict}
        )
