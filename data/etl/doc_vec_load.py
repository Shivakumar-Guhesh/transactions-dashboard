import datetime
import os
import random
import sys
from typing import Any, Dict, List, cast

import pandas as pd
from langchain_chroma import Chroma
from langchain_ollama import OllamaEmbeddings
from sqlalchemy import MetaData, Table, create_engine, select
from sqlalchemy.sql.schema import Table as TableType

from .config import Settings
from .constants import DATE_FORMATTER
from .utils import logger, setup_logging

settings = Settings.model_validate({})

# ============================================================================ #
#                                   CONSTANTS                                  #
# ============================================================================ #

TABLE_NAME = "TRANSACTION_FACT"
CURRENT_DIR = os.path.dirname(__file__)
CURRENT_DATE_STR = datetime.datetime.now().strftime(DATE_FORMATTER)
DATE_CONTROL_FILE_PATH = os.path.join(CURRENT_DIR, "doc_vec_load_dt_ctrl.txt")
LOG_FILE_DIR = os.path.join(CURRENT_DIR, "logs")
EMBED_MODEL = "nomic-embed-text"
VECTOR_STORE_PATH = "./db"

TEMPLATES = [
    "A {transaction_type} of {amount:.2f} {currency} happened on {transaction_date} for {transaction_desc} under the {category} category.",
    "For {category}, a {amount:.2f} {currency} {transaction_type} was made at {transaction_desc} on {transaction_date}.",
    "A transaction titled {transaction_desc} under {category} for {amount:.2f} {currency} was recorded on {transaction_date}.",
    "This {amount:.2f} {currency} payment is a {transaction_type} related to {transaction_desc}, filed under the {category} category on {transaction_date}.",
    "On {transaction_date}, a {transaction_type} transaction occurred for {amount:.2f} {currency} related to {transaction_desc}, categorized as {category}.",
]

if settings.database_type.lower() == "sqlite":
    SQLALCHEMY_DATABASE_URL = f"sqlite:///{settings.sqlite_database_path}"
else:
    SQLALCHEMY_DATABASE_URL = (
        f"{settings.database_type}://{settings.database_username}:{settings.database_password}"
        f"@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"
    )


def read_sql_table() -> tuple[pd.DataFrame, str]:
    """
    Reads the entire SQL table into a DataFrame.

    Args:
        table_name (str): The name of the table to read.

    Returns:
        pd.DataFrame: DataFrame containing the table data.
    """

    read_start_time = datetime.datetime.now()

    if not os.path.isfile(DATE_CONTROL_FILE_PATH):
        LAST_PROCESSED_DATE = datetime.datetime.strptime("19000101", DATE_FORMATTER)
        logger.info("Date control file not found.")
    else:
        with open(DATE_CONTROL_FILE_PATH, "r") as date_control_file:
            LAST_PROCESSED_DATE = datetime.datetime.strptime(
                date_control_file.read().strip(), DATE_FORMATTER
            )

    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    metadata = MetaData()
    metadata.reflect(bind=engine)

    try:
        table_obj: TableType = cast(
            TableType, Table(TABLE_NAME, metadata, autoload_with=engine)
        )

        with engine.connect() as connection:
            if not engine.dialect.has_table(connection, TABLE_NAME):
                logger.warning(f"No table named {TABLE_NAME}. Exiting.")
                sys.exit(0)
            logger.info(f"Connected to database and found table {TABLE_NAME}.")
            logger.info(
                f"Reading records later than {LAST_PROCESSED_DATE.strftime(DATE_FORMATTER)} {TABLE_NAME}."
            )
            select_statement = select(table_obj).where(
                table_obj.c.TRANSACTION_DATE > LAST_PROCESSED_DATE
            )
            select_result = connection.execute(select_statement)
            tran_fact_df = pd.DataFrame(
                select_result.fetchall(), columns=select_result.keys()
            )
        CURR_PRCS_DATE = tran_fact_df["TRANSACTION_DATE"].max().strftime(DATE_FORMATTER)
    except Exception as e:
        logger.critical(f"Failed to load records into {TABLE_NAME}. {e}")
        raise

    read_duration = (datetime.datetime.now() - read_start_time).total_seconds()
    logger.info(f"Read {tran_fact_df.shape[0]} records.")
    logger.info(f"Table read completed in {read_duration:.2f} seconds.")
    return tran_fact_df, CURR_PRCS_DATE


def format_row(row) -> Dict[str, Any]:
    """
    Generates a semantically varied text document and extracts structured
    metadata from a single transaction row for vector indexing.
    Args:
        row (pd.Series): A single row from the transaction DataFrame.

    Returns:
        Dict[str, Any]: Dict of 'document' (string) and 'metadata' (dict).
    """
    metadata = {
        "transaction_date": str(row["TRANSACTION_DATE"]),
        "category": row["CATEGORY"],
        "amount": float(row["AMOUNT"]),
        "transaction_type": row["TRANSACTION_TYPE"],
        "currency": row["CURRENCY"],
        "transaction_desc": row["TRANSACTION"],  # Retain original description
    }
    return {
        "document": random.choice(TEMPLATES).format(**metadata),
        "metadata": metadata,
    }


def convert_df_to_documents(tran_fact_df: pd.DataFrame) -> List[Dict[str, Any]]:
    """
    Converts the DataFrame records into a list of document dictionaries.

    Args:
        tran_fact_df (pd.DataFrame): DataFrame containing transaction records.

    Returns:
        list[str]: List of document string.
    """
    conversion_start_time = datetime.datetime.now()
    logger.info(
        f"Starting dataframe to document conversion for {tran_fact_df.shape[0]} records."
    )
    documents: List[Dict[str, Any]] = tran_fact_df.apply(format_row, axis=1).tolist()
    conversion_duration = (
        datetime.datetime.now() - conversion_start_time
    ).total_seconds()
    logger.info(
        f"Dataframe to documents conversion completed in {conversion_duration:.2f} seconds."
    )
    return documents


def load_vector_store(documents: List[Dict[str, Any]], curr_prcs_date: str) -> None:
    """
    Loads the documents into a Chroma vector store with embeddings.

    Args:
        documents (List[Dict[str, Any]]): List of document dictionaries.
    """
    load_start_time = datetime.datetime.now()
    logger.info(f"Starting vector store loading for {len(documents)} documents.")
    embed_start_time = datetime.datetime.now()
    logger.info(f"Creating embeddings for {len(documents)} documents.")

    embeddings = OllamaEmbeddings(model=EMBED_MODEL)

    embed_duration = (datetime.datetime.now() - embed_start_time).total_seconds()
    logger.info(f"Embedding phase completed in {embed_duration:.2f} seconds.")

    vector_store = Chroma(
        embedding_function=embeddings,
        persist_directory=VECTOR_STORE_PATH,
        collection_name="transactions_collection",
    )

    texts = [doc["document"] for doc in documents]
    metadatas = [doc["metadata"] for doc in documents]

    vector_store.add_texts(texts=texts, metadatas=metadatas, persist=True)

    load_duration = (datetime.datetime.now() - load_start_time).total_seconds()
    logger.info(f"Vector store loading completed in {load_duration:.2f} seconds.")

    with open(DATE_CONTROL_FILE_PATH, "w") as date_control_file:
        date_control_file.write(f"{curr_prcs_date}")


def main():

    setup_logging(CURRENT_DIR)
    logger.info(f"Started processing for {CURRENT_DATE_STR}")

    process_start_time = datetime.datetime.now()
    tran_fact_df, CURR_PRCS_DATE = read_sql_table()

    total_duration = (datetime.datetime.now() - process_start_time).total_seconds()
    logger.info(f"Process completed successfully in {total_duration:.2f} seconds.")

    documents = convert_df_to_documents(tran_fact_df)

    load_vector_store(documents, CURR_PRCS_DATE)

    total_duration = (datetime.datetime.now() - process_start_time).total_seconds()
    logger.info(f"Process completed successfully in {total_duration:.2f} seconds.")


if __name__ == "__main__":
    main()
