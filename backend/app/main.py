import socket

import uvicorn

# from app.schemas import *
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from .routers import auth, transactions, user

# Base.metadata.create_all(bind=engine)

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


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

    # ============================================================================ #
    #                       This part serves on ipv4 address                       #
    # ============================================================================ #

    # hostname = socket.getfqdn()

    # s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # s.connect(("8.8.8.8", 80))
    # local_host = s.getsockname()[0]

    # uvicorn.run(
    #     "app.main:app",
    #     host=local_host,
    #     port=5000,
    #     # log_level="info",
    #     reload=True,
    #     use_colors=True,
    # )

    # ============================================================================ #
    #                         This part serves on localhost                        #
    # ============================================================================ #

    uvicorn.run(
        "app.main:app",
        host="localhost",
        port=5000,
        # log_level="info",
        reload=True,
        use_colors=True,
    )
