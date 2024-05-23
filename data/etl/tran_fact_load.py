# /d/transactions_dashboard: >python -m data.etl.tran_fact_load
import datetime
import logging
import os
import sys

import pandas as pd
from sqlalchemy import create_engine

from data.constants import DATE_FORMATTER, TIMESTAMP_FORMATTER

from ..config import Settings

settings = Settings()

CURRENT_DATE = datetime.datetime.now().strftime(DATE_FORMATTER)
DATE_CONTROL_FILE_PATH = os.path.join(os.path.dirname(__file__), "dt_ctrl.txt")

# ============================================================================ #
#                                    LOGGING                                   #
# ============================================================================ #
logger = logging.getLogger(__name__)
fileHandler = logging.FileHandler(
    f"{__file__}_logs_{datetime.datetime.now().strftime(TIMESTAMP_FORMATTER)}.log"
)
fmt = logging.Formatter(
    "%(name)s: %(asctime)s | %(levelname)s | %(filename)s:%(lineno)s  >>> %(message)s"
)
fileHandler.setFormatter(fmt)
logger.addHandler(fileHandler)
logger.setLevel(logging.INFO)
logger.info(f"Started processing for {CURRENT_DATE}")


def handle_unhandled_exception(exc_type, exc_value, exc_traceback):
    if issubclass(exc_type, KeyboardInterrupt):
        # Will call default excepthook
        sys.__excepthook__(exc_type, exc_value, exc_traceback)
        return
        # Create a critical level log message with info from the except hook.
    logger.critical(
        "Unhandled exception", exc_info=(exc_type, exc_value, exc_traceback)
    )


# Assign the excepthook to the handler
sys.excepthook = handle_unhandled_exception


# ============================ LAST PROCESSED DATE =========================== #
if not (os.path.isfile(DATE_CONTROL_FILE_PATH)):
    last_processed_date = datetime.datetime.strptime("19000101", DATE_FORMATTER)
else:
    f = open(DATE_CONTROL_FILE_PATH, "r")
    last_processed_date = datetime.datetime.strptime(f.read(), DATE_FORMATTER)
    f.close()
logger.info(f"Reading records later than {last_processed_date}")


INPUT_FILE = settings.input_file
TABLE_NAME = "TRANSACTION_FACT"
SQLALCHEMY_DATABASE_URL: str = (
    f"{settings.database_type}:///{settings.sqlite_database_path}"
)
if settings.database_type != "sqlite":
    SQLALCHEMY_DATABASE_URL = f"{settings.database_type}://{settings.database_username}:{settings.database_password}@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"
engine = create_engine(SQLALCHEMY_DATABASE_URL)

input_df = pd.read_excel(INPUT_FILE, index_col=None)
# tran_dtl_df = pd.to_datetime(tran_dtl_df["Date"],format='%Y%m%d')
tran_fact_df = input_df.loc[input_df["Date"] > last_processed_date]


# ============== Adding USER_ID_COLUMN with value 1 for all rows ============= #
tran_fact_df.insert(
    0, "USER_ACCOUNT_ID", value=[1 for i in range(tran_fact_df.shape[0])]
)
tran_fact_df.insert(
    6, "INSRT_USER", value=["ETL_MGR" for i in range(tran_fact_df.shape[0])]
)


tran_fact_df = tran_fact_df.rename(
    columns={
        "USER_ACCOUNT_ID": "USER_ACCOUNT_ID",
        "Date": "TRANSACTION_DATE",
        "Transaction": "TRANSACTION",
        "Category": "CATEGORY",
        "Income/Expense": "TRANSACTION_TYPE",
        "Amount": "AMOUNT",
        "Mode": "TRANSACTION_MODE",
        "INSRT_USER": "INSRT_USER",
    }
)

# query = """
# SELECT * FROM USER_ACCOUNT
# """
# print(pd.read_sql(query, con=engine))

# ============================================================================ #
#                                  TABLE LOAD                                  #
# ============================================================================ #
tran_fact_df.to_sql(TABLE_NAME, con=engine, if_exists="append", index=False)
logger.info(f"Inserted {tran_fact_df.shape[0]} records into {TABLE_NAME}")

f = open(DATE_CONTROL_FILE_PATH, "w")
f.write(f"{CURRENT_DATE}")
f.close()

logger.info(f"Completed processing for {CURRENT_DATE}")
