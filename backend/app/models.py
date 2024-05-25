from sqlalchemy import Column, Integer, String
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
