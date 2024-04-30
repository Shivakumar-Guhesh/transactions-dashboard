from typing import Dict
import pandas as pd
from fastapi import APIRouter, FastAPI, HTTPException, Response, status


from .. import schemas
from ..constants import INPUT_FILE

from app import utils

router = APIRouter(
    # prefix="/",
    # tags=[],
)  # TODO: Add predix url path and use it for naming the file as well

data = pd.read_excel(INPUT_FILE)


data["Month"] = utils.add_period(data=data, col="Date")

data["Date"] = pd.to_datetime(data["Date"])

filters: Dict[str, list[str]] = dict()

filters["categories_to_skip_all_transacations"] = []
filters["categories_to_skip_expense"] = []
filters["categories_to_skip_income"] = []

# categories_to_skip_all_transacations = ["Lending"]
# categories_to_skip_expense = []
# categories_to_skip_expense = ["Security Deposit"]

cat_expense_sum = utils.group_wise_aggregation(
    data=data,
    groupby_col="Category",
    aggregate_col="Amount",
    filter_col="Income/Expense",
    filter_val="Expense",
    sort=True,
)


@router.get("/cat_expense_sum")
def get_cat_expense_sum():
    """GET endpoint for cat_expense_sum.
    Returns cateogry-wise summarized data

    Returns:
        result: cateogry-wise summarized data
    """
    # result = cat_expense_sum.to_dict("records")
    # result = cat_expense_sum.to_dict()

    # print(json.dumps(result))
    if cat_expense_sum.empty:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Not found")
    # return JSONResponse(content=result)
    return Response(
        cat_expense_sum.to_json(orient="records"), media_type="application/json"
    )


@router.get("/data")
def get_data(limit: int = 100, page=1):
    # return data.to_dict("records")
    if data.empty:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Not found")
    # return JSONResponse(content=result)
    paged_data = data.tail(limit)
    return Response(paged_data.to_json(orient="records"), media_type="application/json")


@router.post("/filters", status_code=status.HTTP_201_CREATED)
def post_create_filters(payload: schemas.FilterPayload):
    """POST endpoint for adding filters
    Sample request:
        {
            "filter": "categories_to_skip_all_transacations",
            "categories": [
                "Lending"
            ]
        }
    Parameters:
        payload: payload of type FilterPayload

    Returns:
        <variable>: Description of the return value

    """
    filters[payload.filter] = payload.categories
    print(filters)
    utils.dump_json("./filters.json", filters)
    return f"Added {payload.categories} to filter {payload.filter}"
