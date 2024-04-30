from typing import Dict
from fastapi import FastAPI
import pandas as pd
from app.schemas import *
import uvicorn
import socket

from . import models
from .database import engine, Base

from .routers import transactions, user, auth

Base.metadata.create_all(bind=engine)

app = FastAPI()


@app.get("/")
def root():
    return "Welcome to fastapi localhost"


app.include_router(transactions.router)
app.include_router(user.router)
app.include_router(auth.router)


if __name__ == "__main__":
    # uvicorn.run(
    #     "fastapi_app:app", host="192.168.1.12", port=5000, log_level="info", reload=True
    # )

    hostname = socket.getfqdn()
    # local_host = socket.gethostbyname_ex(hostname)[2][1]
    # local_host = socket.gethostbyname_ex(hostname)[-1][-1]

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    local_host = s.getsockname()[0]

    uvicorn.run(
        "app.main:app", host=local_host, port=5000, log_level="info", reload=True
    )
