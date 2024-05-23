import pandas as pd
from time import time
from sqlalchemy import create_engine
import os

import configobj

config = configobj.ConfigObj("../.env")
input_file = config["input_file"]
database_type = config["database_type"]
database_hostname = config["database_hostname"]
database_port = config["database_port"]
database_password = config["database_password"]
database_name = config["database_name"]
database_username = config["database_username"]
sqlite_database_path = config["sqlite_database_path"]

SQLALCHEMY_DATABASE_URL: str
if database_type == "sqlite":
    # "sqlite:////home/stephen/db1.db"
    SQLALCHEMY_DATABASE_URL = (
        f"{database_type}:///{sqlite_database_path}/transactions.db"
    )
else:
    SQLALCHEMY_DATABASE_URL = f"{database_type}://{database_username}:{database_password}@{database_hostname}:{database_port}/{database_name}"


def main():
    engine = create_engine(SQLALCHEMY_DATABASE_URL)

    df = pd.read_excel(input_file)

    table_name = "tran_dtl"

    print(pd.io.sql.get_schema(df, name=table_name, con=engine))  #

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists="replace")

    df.to_sql(table_name, con=engine, if_exists="append")

    t_start = time()
    df.to_sql(table_name, con=engine, if_exists="append")
    t_end = time()
    print(f"Finished inserting %.3f seconds AKA {t_end - t_start}" % (t_end - t_start))


if __name__ == "__main__":

    main()

# query = """
# SELECT COUNT(*) FROM yellow_taxi_data
# """
# pd.read_sql(query,con=engine)
