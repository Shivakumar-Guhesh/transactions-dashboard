import datetime
import os
import sys
from typing import Any, Dict, List, cast

import chromadb
import numpy as np
import pandas as pd
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
CHROMA_COLLECTION_NAME = "transactions_collection"

SENTENCE_TEMPLATE_STRING = "{transaction_type} transaction under category: {category} with description: {transaction_desc}."


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

    transaction_dt = datetime.datetime.combine(
        row["TRANSACTION_DATE"], datetime.time.min
    )
    metadata = {
        "transaction_timestamp": transaction_dt.timestamp(),
        "category": str(row["CATEGORY"]).strip().lower(),
        "amount": float(row["AMOUNT"]),
        "transaction_type": str(row["TRANSACTION_TYPE"]).strip().lower(),
        "currency": str(row["CURRENCY"]).strip().lower(),
        "transaction_desc": str(row["TRANSACTION"]).strip().lower(),
        "year": transaction_dt.year,
        "month": transaction_dt.month,
        "day": transaction_dt.day,
    }
    return {
        "document": SENTENCE_TEMPLATE_STRING.format(**metadata),
        "metadata": metadata,
        "id": str(row["TRANSACTION_FACT_ID"]),
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
    if tran_fact_df.empty:
        logger.warning("DataFrame is empty, skipping conversion.")
        return []
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
    Loads the documents into a Chroma vector store using the native ChromaDB API.

    Args:
        documents (List[Dict[str, Any]]): List of document dictionaries.
    """

    doc_count = len(documents)
    logger.info(f"Starting vector store loading for {doc_count} documents.")

    if doc_count == 0:
        logger.info("No new documents to index. Exiting load_vector_store.")
        return

    embed_start_time = datetime.datetime.now()
    embeddings = OllamaEmbeddings(model=EMBED_MODEL)

    texts = [doc["document"] for doc in documents]
    metadatas = [doc["metadata"] for doc in documents]
    vectors = embeddings.embed_documents(texts)
    if len(vectors) != doc_count:
        logger.critical(
            f"Embedding mismatch: Expected {doc_count} vectors but got {len(vectors)}. "
            "Halting process."
        )
        return
    embed_duration = (datetime.datetime.now() - embed_start_time).total_seconds()
    logger.info(f"Embedding phase completed in {embed_duration:.2f} seconds.")
    np_vectors = np.array(vectors, dtype=np.float32)

    logger.info(
        f"Converted {len(vectors)} vectors to NumPy array with shape {np_vectors.shape}."
    )
    ids = [doc["id"] for doc in documents]

    chroma_start_time = datetime.datetime.now()

    try:
        client = chromadb.PersistentClient(path=VECTOR_STORE_PATH)
    except Exception as e:
        logger.critical(
            f"Failed to initialize Chroma PersistentClient at {VECTOR_STORE_PATH}. {e}"
        )
        raise

    try:
        collection = client.get_or_create_collection(name=CHROMA_COLLECTION_NAME)
    except Exception as e:
        logger.critical(
            f"Failed to get/create Chroma collection '{CHROMA_COLLECTION_NAME}'. {e}"
        )
        raise

    try:
        logger.info(f"Adding {doc_count} documents to Chroma collection.")
        collection.upsert(
            embeddings=np_vectors,
            documents=texts,
            metadatas=metadatas,
            ids=ids,
        )
    except Exception as e:
        logger.critical(f"Failed to add documents to Chroma collection. {e}")
        raise

    chroma_duration = (datetime.datetime.now() - chroma_start_time).total_seconds()
    logger.info(f"ChromaDB addition completed in {chroma_duration:.2f} seconds.")

    with open(DATE_CONTROL_FILE_PATH, "w") as date_control_file:
        date_control_file.write(f"{curr_prcs_date}")


def main():

    setup_logging(CURRENT_DIR)
    logger.info(f"Started processing for {CURRENT_DATE_STR}")

    process_start_time = datetime.datetime.now()
    tran_fact_df, CURR_PRCS_DATE = read_sql_table()

    documents = convert_df_to_documents(tran_fact_df)

    load_vector_store(documents, CURR_PRCS_DATE)

    total_duration = (datetime.datetime.now() - process_start_time).total_seconds()
    logger.info(f"Process completed successfully in {total_duration:.2f} seconds.")


if __name__ == "__main__":
    main()
