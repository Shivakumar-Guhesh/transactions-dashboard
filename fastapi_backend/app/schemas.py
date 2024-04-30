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
    id: int
    email: EmailStr
    created_at: datetime

    class Config:
        orm_mode = True


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
