import datetime

from sqlalchemy import Column, Date, Float, ForeignKey, Integer, String
from sqlalchemy.sql.expression import text
from sqlalchemy.sql.sqltypes import TIMESTAMP

from .database import Base


class User(Base):
    def __init__(self, email: str, hashed_password: str, role: None, insrt_user: str):
        self.email = email
        self.hashed_password = hashed_password
        if role != None:
            self.role = role
        self.insrt_user = insrt_user

    __tablename__ = "user_account"
    user_account_id = Column(Integer, primary_key=True, nullable=False)
    email = Column(String, nullable=False, unique=True)
    hashed_password = Column(String, nullable=False)
    role = Column(String, server_default="NORMAL")
    insrt_ts = Column(
        TIMESTAMP(timezone=True),
        nullable=False,
        server_default=text("CURRENT_TIMESTAMP"),
    )
    insrt_user = Column(String, nullable=False)


class TransactionFact(Base):
    # def __init__(
    #     self,
    #     transaction_date: datetime.date,
    #     transaction: str,
    #     category: str,
    #     transaction_type: str,
    #     amount: float,
    #     transaction_mode: str,
    #     currency: str,
    #     insrt_user: str,
    # ):
    #     self.transaction_date = transaction_date
    #     self.transaction = transaction
    #     self.category = category
    #     self.transaction_type = transaction_type
    #     self.amount = amount
    #     self.transaction_mode = transaction_mode
    #     self.currency = currency
    #     self.insrt_user = insrt_user

    __tablename__ = "transaction_fact"
    transaction_fact_id = Column(Integer, primary_key=True, nullable=False)
    user_account_id = Column(
        Integer, ForeignKey("users.id", ondelete="ForeignKey"), nullable=False
    )
    transaction_date = Column(Date, nullable=False)
    transaction = Column(String, nullable=False)
    category = Column(String, nullable=False)
    transaction_type = Column(String, nullable=False)
    amount = Column(Float, nullable=False)
    transaction_mode = Column(String, nullable=False)
    currency = Column(String, nullable=False)
    insrt_ts = Column(
        TIMESTAMP(timezone=True),
        nullable=False,
        server_default=text("CURRENT_TIMESTAMP"),
    )
    insrt_user = Column(String, nullable=False)
