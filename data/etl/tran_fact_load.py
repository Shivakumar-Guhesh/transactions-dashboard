# /d/transactions_dashboard: >python -m data.etl.tran_fact_load
"""
This script reads all records  between (LAST_PROCESSED_DATE and CURRENT_DATE) and loads into TRANSACTION_FACT table
"""
import datetime
import os
import sys

import pandas as pd
from sqlalchemy import MetaData, Table, create_engine, insert

from .config import Settings
from .constants import DATE_FORMATTER
from .utils import logger, setup_logging

settings = Settings.model_validate({})

# ============================================================================ #
#                                   CONSTANTS                                  #
# ============================================================================ #

INPUT_FILE = settings.input_file
TABLE_NAME = "TRANSACTION_FACT"
CURRENT_DIR = os.path.dirname(__file__)
CURRENT_DATE_STR = datetime.datetime.now().strftime(DATE_FORMATTER)
DATE_CONTROL_FILE_PATH = os.path.join(CURRENT_DIR, "tran_fact_load_dt_ctrl.txt")
LOG_FILE_DIR = os.path.join(CURRENT_DIR, "logs")

if settings.database_type.lower() == "sqlite":
    SQLALCHEMY_DATABASE_URL = f"sqlite:///{settings.sqlite_database_path}"
else:
    SQLALCHEMY_DATABASE_URL = (
        f"{settings.database_type}://{settings.database_username}:{settings.database_password}"
        f"@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"
    )

REQUIRED_EXCEL_COLUMNS_MAP = {
    "Date": "TRANSACTION_DATE",
    "Transaction": "TRANSACTION",
    "Category": "CATEGORY",
    "Income/Expense": "TRANSACTION_TYPE",
    "Amount": "AMOUNT",
    "Mode": "TRANSACTION_MODE",
}
REQUIRED_EXCEL_COLUMNS = set(REQUIRED_EXCEL_COLUMNS_MAP.keys())

# ============================================================================ #
#                                    EXTRACT                                   #
# ============================================================================ #


def extract_data() -> tuple[pd.DataFrame, str]:
    """
    Reads data from the source file and filters records based on the
    last processed date.

    Returns:
        tuple[pd.DataFrame, str]: The filtered DataFrame and the new max date string (CURR_PRCS_DATE).
    """
    extract_start_time = datetime.datetime.now()

    if not os.path.isfile(DATE_CONTROL_FILE_PATH):
        LAST_PROCESSED_DATE = datetime.datetime.strptime("19000101", DATE_FORMATTER)
        logger.info("Date control file not found.")
    else:
        with open(DATE_CONTROL_FILE_PATH, "r") as date_control_file:
            LAST_PROCESSED_DATE = datetime.datetime.strptime(
                date_control_file.read().strip(), DATE_FORMATTER
            )

    logger.info(
        f"Reading records later than {LAST_PROCESSED_DATE.strftime(DATE_FORMATTER)} and less than {CURRENT_DATE_STR}"
    )

    if not os.path.isfile(INPUT_FILE):
        logger.error(f"Input file not found: {INPUT_FILE}")
        raise FileNotFoundError(f"Input file required: {INPUT_FILE}")

    try:
        input_df = pd.read_excel(INPUT_FILE, index_col=None)
        logger.info(f"Read {input_df.shape[0]} records from source file: {INPUT_FILE}")

        missing_cols = REQUIRED_EXCEL_COLUMNS - set(input_df.columns)
        if missing_cols:
            raise ValueError(f"Missing required columns: {missing_cols}")

    except Exception as e:
        logger.error(f"Failed to read and validate input file. ETL Failed: {e}")
        raise

    CURRENT_DATE_DT = datetime.datetime.strptime(CURRENT_DATE_STR, DATE_FORMATTER)

    tran_fact_df = input_df[
        (input_df["Date"] > LAST_PROCESSED_DATE) & (input_df["Date"] < CURRENT_DATE_DT)
    ].copy()

    extract_duration = (datetime.datetime.now() - extract_start_time).total_seconds()
    logger.info(f"Filtered down to {tran_fact_df.shape[0]} new records for load.")
    logger.info(f"Extract Stage completed in {extract_duration:.2f} seconds.")

    if tran_fact_df.empty:
        logger.warning("No new records to process. Exiting.")
        sys.exit(0)

    CURR_PRCS_DATE = tran_fact_df["Date"].max().strftime(DATE_FORMATTER)

    return tran_fact_df, CURR_PRCS_DATE


def transform_data(tran_fact_df: pd.DataFrame) -> pd.DataFrame:
    """
    Applies transformations like adding derived columns and renaming columns.

    Args:
        tran_fact_df (pd.DataFrame): The extracted, raw data.

    Returns:
        pd.DataFrame: The transformed data ready for loading.
    """
    transform_start_time = datetime.datetime.now()

    # ============== Adding USER_ID_COLUMN with value 1 for all rows ============= #
    tran_fact_df.insert(0, "USER_ID", value=settings.default_user_id)
    # ========= Adding INSRT_USER column with value ETL_MGR for all rows ========= #
    tran_fact_df["INSRT_USER"] = "ETL_MGR"

    tran_fact_df = tran_fact_df.rename(columns=REQUIRED_EXCEL_COLUMNS_MAP)

    transform_duration = (
        datetime.datetime.now() - transform_start_time
    ).total_seconds()
    logger.info(f"Transform Stage completed in {transform_duration:.2f} seconds.")

    return tran_fact_df


def load_data(tran_fact_df: pd.DataFrame, curr_prcs_date: str) -> None:
    """
    Loads the transformed data into the database and updates the date control file.

    Args:
        tran_fact_df (pd.DataFrame): The data ready for database insertion.
        curr_prcs_date (str): The max transaction date processed in this run.
    """
    load_start_time = datetime.datetime.now()

    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    metadata = MetaData()
    metadata.reflect(bind=engine)

    insert_rows_count = tran_fact_df.shape[0]

    try:
        tran_fact_table = Table(TABLE_NAME, metadata, autoload_with=engine)

        insert_statement = insert(tran_fact_table)

        with engine.begin() as connection:
            if not engine.dialect.has_table(connection, TABLE_NAME):
                logger.warning(f"No table named {TABLE_NAME}. Exiting.")
                sys.exit(0)
            logger.info(f"Connected to database and found table {TABLE_NAME}.")
            data_to_insert = tran_fact_df.to_dict(orient="records")
            connection.execute(insert_statement, data_to_insert)

    except Exception as e:
        logger.critical(
            f"Failed to load {insert_rows_count} records into {TABLE_NAME}. ROLLBACK performed. Error: {e}"
        )
        raise

    load_duration = (datetime.datetime.now() - load_start_time).total_seconds()

    logger.info(f"Inserted {insert_rows_count} records into {TABLE_NAME}")
    logger.info(f"Load Stage completed in {load_duration:.2f} seconds.")

    with open(DATE_CONTROL_FILE_PATH, "w") as date_control_file:
        date_control_file.write(f"{curr_prcs_date}")

    logger.info(f"Completed processing records till {curr_prcs_date}")


# ============================================================================ #
#                                  ENTRY POINT                                 #
# ============================================================================ #


def main():

    setup_logging(CURRENT_DIR)
    logger.info(f"Started processing for {CURRENT_DATE_STR}")

    process_start_time = datetime.datetime.now()

    raw_df, curr_prcs_date = extract_data()

    transformed_df = transform_data(raw_df)

    load_data(transformed_df, curr_prcs_date)

    total_duration = (datetime.datetime.now() - process_start_time).total_seconds()
    logger.info(f"Process completed successfully in {total_duration:.2f} seconds.")


if __name__ == "__main__":
    main()
