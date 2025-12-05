import datetime

from pydantic import BaseModel, ConfigDict, EmailStr


class UserCreateResponse(BaseModel):
    user_id: int
    email: EmailStr
    insrt_ts: datetime.datetime

    model_config = ConfigDict(from_attributes=True)


class UserCreateRequest(BaseModel):
    email: EmailStr
    password: str


class UserLoginRequest(BaseModel):
    email: EmailStr
    password: str
