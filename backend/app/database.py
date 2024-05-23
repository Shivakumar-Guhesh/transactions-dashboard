import os
from dotenv import load_dotenv
import sqlite3
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import psycopg2
from psycopg2.extras import RealDictCursor
import time
from .config import Settings

settings = Settings()

SQLALCHEMY_DATABASE_URL: str
if settings.database_type == "sqlite":
    # "sqlite:////home/stephen/db1.db"
    SQLALCHEMY_DATABASE_URL = (
        f"{settings.database_type}:///{settings.sqlite_database_path}/transactions.db"
    )
else:
    SQLALCHEMY_DATABASE_URL = f"{settings.database_type}://{settings.database_username}:{settings.database_password}@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"


engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# while True:

#     try:
#         conn = psycopg2.connect(host='localhost', database='fastapi', user='postgres',
#                                 password='password123', cursor_factory=RealDictCursor)
#         cursor = conn.cursor()
#         print("Database connection was succesfull!")
#         break
#     except Exception as error:
#         print("Connecting to database failed")
#         print("Error: ", error)
#         time.sleep(2)


# from .config import settings


# # conn = sqlite3.connect("../data/transactions.db")
# conn = sqlite3.connect("D:/transactions_dashboard/fastapi_backend/data/transactions.db")
# cursor = conn.cursor()
# cursor.execute(
#     """
# CREATE TABLE users (
#         id INTEGER NOT NULL,
#         email VARCHAR NOT NULL,
#         password VARCHAR NOT NULL,
#         created_at TIMESTAMP DEFAULT now() NOT NULL,
#         PRIMARY KEY (id),
#         UNIQUE (email)
# )
# """
# )
# # conn.commit()
# conn.close()


# while True:

#     try:
#         # conn = psycopg2.connect(
#         #     host="localhost",
#         #     database="fastapi",
#         #     user="postgres",
#         #     password="password123",
#         #     cursor_factory=RealDictCursor,
#         # )
#         conn = sqlite3.connect(f"{sqllite_database_path}/transactions.db")
#         # conn = sqlite3.connect("../data/transactions.db")
#         # conn = sqlite3.connect("../fastapi_backend/data/transactions.db")
#         cursor = conn.cursor()
#         print("Database connection was succesfull!")
#         break
#     except Exception as error:
#         print("Connecting to database failed")
#         print("Error: ", error)
#         time.sleep(2)