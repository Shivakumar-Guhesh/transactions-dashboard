from datetime import MINYEAR, date, datetime

from pydantic import BaseModel, ConfigDict, Field


class TransactionsFiltersRequest(BaseModel):
    exclude_expenses: list[str] = Field(default_factory=list)
    exclude_incomes: list[str] = Field(default_factory=list)
    start_date: str = date(MINYEAR, 1, 1).strftime("%Y%m%d")
    end_date: str = date.today().strftime("%Y%m%d")


class TransactionsDataResponse(BaseModel):
    transaction_fact_id: int
    user_id: int
    transaction_date: date
    transaction: str
    category: str
    transaction_type: str
    amount: float
    transaction_mode: str
    currency: str
    insrt_ts: datetime
    insrt_user: str

    model_config = ConfigDict(from_attributes=True)


class TransactionsDistinctValuesListResponse(BaseModel):
    values: list[str]

    model_config = ConfigDict(from_attributes=True)


class TransactionsTotalAmountResponse(BaseModel):
    total: float

    model_config = ConfigDict(from_attributes=True)


class TransactionsGroupAmountResponse(BaseModel):
    group_amount: dict[str, float]

    model_config = ConfigDict(from_attributes=True)
