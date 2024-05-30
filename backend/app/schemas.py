from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr


class FilterPayload(BaseModel):
    """Pydantic class for filters payload .

    Variables:
        filter: filter_name
        categories: list of categories
    """

    filter: str
    categories: list[str]


class UserOut(BaseModel):
    user_account_id: int
    email: EmailStr
    insrt_ts: datetime

    class Config:
        from_attributes = True


class UserCreate(BaseModel):
    email: EmailStr
    password: str


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    id: Optional[str] = None


class TransactionsFiltersIn(BaseModel):
    exclude_expenses: list[str] = []
    exclude_incomes: list[str] = []
