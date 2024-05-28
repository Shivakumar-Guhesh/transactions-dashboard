import difflib
import json
import typing

import numpy as np
import pandas as pd
from passlib.context import CryptContext
from tabulate import tabulate

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def convert_to_datetime(data: pd.DataFrame, col: str) -> pd.Series:
    """Function to convert date field into datetime.

    Parameters:
        data: Pandas Dataframe
        col: Name of the date column in the dataframe to be converted

    Returns:
        Column converted to datetime
    """
    pd.to_datetime(data[col])
    return data[col]


def add_period(data: pd.DataFrame, col: str) -> pd.Series:
    """Add a month-period column to a pandas dataframe.

    Parameters:
        data: Pandas Dataframe
        col: Name of the date column from which month-period can be created.

    Returns:
        New month-period column
    """
    return data[col].dt.to_period("M")


def print_divider():
    """Prints a divider line"""
    for i in range(80):
        print("-", end="")
    print("\n")


def wait_for_input():
    """Pauses the execution of the program until any key is pressed"""

    input("Press Enter to continue.")


def basic_analysis(data: pd.DataFrame):
    """Prints basic info about the dataframe passed.

    Parameters:
        data: Pandas Dataframe

    """
    print("Basic Analysis".center(80, " "))
    print("\n")
    print(tabulate(data.tail().itertuples(), tablefmt="rounded_grid"))
    print()
    print(data.info())
    print("\nShape: ", data.shape)
    print("\nColumns: ", data.columns)


def delete_data(
    data: pd.DataFrame, categories: list[str], delete_income: bool, delete_expense: bool
) -> pd.DataFrame:
    """
        Returns a new dataframe by removing income and/or expense transactions of specified categories from the dataframe.


    Parameters:
        data: Pandas Dataframe
        categories: List of categories to be deleted based on following flags.
        delete_income: If this flag is true, income transactions of the chosen categories will be deleted
        delete_expense: If this flag is true, expense transactions of the chosen categories will be deleted

    Returns:
        data: Input pandas dataframe with selected records deleted
    """
    if delete_income and delete_expense:
        for category in categories:
            data = data[data["Category"] != category]
        return data
    if delete_income:
        for category in categories:
            mask = (data["Category"] == category) & (data["Income/Expense"] == "Income")
            data = data[~mask]
        return data
    if delete_expense:
        for category in categories:
            mask = (data["Category"] == category) & (
                data["Income/Expense"] == "Expense"
            )
            data = data[~mask]
        return data
    return data


def print_multiple_column_value(data: pd.DataFrame, col1: str, col2: str):
    """Checks and prints all records which have multiple corresponding values.

    Parameters:
        data: Pandas Dataframe
        col1: Column for which records are selected for checking
        col2: Column on which records are compared for multiple values
    """
    print_divider()
    temp = data[[col1, col2]]

    temp_dict_with_duplicates = {k: g[col2].tolist() for k, g in temp.groupby(col1)}

    temp_dict = {}
    for key, value in temp_dict_with_duplicates.items():
        temp_dict[key] = set(value)

    found_multiple_values = False
    for key, value in temp_dict.items():
        if len(value) > 1:
            print(key, value)
            found_multiple_values = True
    if not found_multiple_values:
        print("No multiple value found")
    print_divider()


def find_close_matches(strings: list[str]):
    """Finds and prints similar strings for all string in a list of strings.

    Parameters:
        strings: List of strings

    """

    strings = list(set(strings))
    for string in strings:
        matches = difflib.get_close_matches(string, strings, cutoff=0.5)
        print(string, " : ", matches)


def extract_month(data: pd.DataFrame) -> list[str]:
    """Returns list of unique months

    Parameters:
        data: Pandas Dataframe

    Returns:
        months: List of unique months(month-year)
    """
    # months = list((data["Month"].unique()).strftime("%Y-%m"))
    months = list((data["Month"].unique()))

    return months


def group_wise_aggregation(
    data: pd.DataFrame,
    groupby_col: str,
    aggregate_col: str,
    aggregate_func="sum",
    filter_col: str | None = None,
    filter_val: str | None = None,
    month: str | None = None,
    sort=False,
) -> pd.DataFrame:
    """Returns a dataframe with groupwise aggregation.

    Parameters:
            data : Input dataframe
            groupby_col : Column on which records has to be grouped
            aggregate_col : Column on which records has to be aggregated
            aggregate_func : Function to be used for aggregation. Defaults to "sum".
            filter_col : Column on which filter condition has to be used. Defaults to None.
            filter_val : Value on which records will be filtered. Defaults to None.
            month : Records will be considered only in this month. Defaults to None.
            sort : Flag to sort the output by aggregate value in descending order. Defaults to False.

    Returns:
        cat_sum: Dataframe with groupwise aggregation
    """

    if filter_col != None:
        data = data[data[filter_col] == filter_val]
    if month != None:
        data = data[data["Month"] == month]
    cat_sum = (
        data.groupby(by=groupby_col)[aggregate_col].agg(aggregate_func).reset_index()
    )
    """
        Equivalent to
        SELECT aggregate_func(aggregate_col) FROM data GROUP BY groupby_col;
    """
    if sort:
        cat_sum.sort_values(by=aggregate_col, ascending=False, inplace=True)
    if groupby_col == "Month":
        cat_sum.columns = [groupby_col.capitalize(), aggregate_func.capitalize()]
    else:
        cat_sum["Month"] = month
        cat_sum.columns = [
            groupby_col.capitalize(),
            aggregate_func.capitalize(),
            "Month",
        ]
    return cat_sum


def create_sankey_df(
    cat_expense_sum: pd.DataFrame, cat_income_sum: pd.DataFrame
) -> pd.DataFrame:
    """Creates and returns a pandas dataframe with columns source, target and weight for sankey chart .

    Parameters:
        cat_expense_sum: category-wise summary dataframe for expenses
        cat_income_sum: category-wise summary dataframe for incomes

    Returns:
        sankey_df: Pandas dataframe
    """
    sankey_income_df = pd.DataFrame(columns=["source", "target", "weight"])
    sankey_expense_df = pd.DataFrame(columns=["source", "target", "weight"])

    sankey_income_df["source"] = cat_income_sum["Category"]
    sankey_income_df.loc[:, "weight"] = cat_income_sum.loc[:, "Sum"]
    sankey_income_df["target"] = "Income"
    sankey_expense_df.loc[:, "weight"] = cat_expense_sum.loc[:, "Sum"]
    sankey_expense_df["target"] = cat_expense_sum["Category"]
    sankey_expense_df["source"] = "Income"
    sankey_df = pd.concat([sankey_income_df, sankey_expense_df])
    # sankey_df = sankey_income_df.append(sankey_expense_df, ignore_index=True)

    return sankey_df


def prepare_wide_data(
    data: pd.DataFrame, months: list[str], columns: list
) -> pd.DataFrame:
    """Created and returns a wide data which can be used for bar chart race.
        Wide data has following properties:
        Each row represents a single period of time
        Each column holds the value for a particular category
        The index contains the time component (optional)

    Parameters:
        data: Pandas dataframe
        months: The time component for bar chart race. Used as index in created dataframe
        columns: List of unique columns which will be present in the created wide data.

    Returns:
        wide_data: Pandas dataframe with wide data
    """
    # all_expense_categories = list(
    #     data[data["Income/Expense"] == "Expense"]["Category"].unique()
    # )
    wide_data = pd.DataFrame(columns=columns, index=months).fillna(0.0)

    for i in range(len(months)):
        temp = group_wise_aggregation(
            data=data,
            groupby_col="Category",
            aggregate_col="Amount",
            filter_col="Income/Expense",
            filter_val="Expense",
            month=months[i],
        )
        # categories = list(temp["Category"].unique())
        for category in columns:
            try:
                wide_data.loc[months[i]][category] += temp[
                    temp["Category"] == category
                ]["Sum"].values[0]
            except:
                pass
            if i > 0:
                wide_data.loc[months[i]][category] += wide_data.loc[months[i - 1]][
                    category
                ]

    return wide_data


def monthly_balance(
    month_expense_sum: pd.DataFrame, month_income_sum: pd.DataFrame
) -> typing.Tuple[list[str], list[int]]:
    """Calculates balance at the end of each month.

    Parameters:
        month_expense_sum: Month-wise summary dataframe for expenses
        month_income_sum: Month-wise summary dataframe for incomes

    Returns:
        months: List of months
        balances: Balance at the end of each month
    """
    months = list(month_expense_sum["Month"].astype(str))
    month_expenses = list(month_expense_sum["Sum"])
    month_incomes = list(month_income_sum["Sum"])
    balances = [0] * len(months)
    balances[0] = month_incomes[0] - month_expenses[0]
    len1 = len(month_expenses)
    len2 = len(month_incomes)
    max_len = max(len1, len2)
    if len1 < max_len:
        month_expenses += [0] * (max_len - len1)
    elif len2 < max_len:
        month_incomes += [0] * (max_len - len2)
    for i in range(1, len(months)):
        balances[i] = balances[i - 1] + month_incomes[i] - month_expenses[i]
    return months, balances


def dump_json(json_file: str, data: dict, mode="w"):
    """Writes python dictionary into json file.

    Parameters:
        json_file: Path of the target json file
        data: Python dictionary which is to be written
        mode: Mode of file writing

    """
    with open(json_file, mode, encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def hash(password: str):
    return pwd_context.hash(password)


def verify(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)
