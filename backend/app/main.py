# ============================================================================ #
#                                     TODO                                     #
# ============================================================================ #
# TODO: Create class for tran_fact in models file
# TODO: Read from table instead of file in transactions.py

# ============================================================================ #
import socket

import uvicorn
from app.schemas import *
from fastapi import FastAPI

from .routers import auth, transactions, user

# Base.metadata.create_all(bind=engine)

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

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    local_host = s.getsockname()[0]

    uvicorn.run(
        "app.main:app",
        host=local_host,
        port=5000,
        # log_level="info",
        reload=True,
        use_colors=True,
    )
