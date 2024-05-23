import os
from fastapi import FastAPI, Response, status, HTTPException, Depends, APIRouter
from sqlalchemy.orm import Session

from ..database import get_db
from .. import models, schemas, utils
from dotenv import load_dotenv

# from ..database import get_db

router = APIRouter(prefix="/users", tags=["Users"])

# /users/
# /users

env_filename = ".env"


load_dotenv(env_filename)
database_type = os.getenv("database_type")


@router.post("/", status_code=status.HTTP_201_CREATED, response_model=schemas.UserOut)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):

    # hash the password - user.password
    hashed_password = utils.hash(user.password)
    user.password = hashed_password

    # new_user = models.User(**user.dict())
    new_user = models.User(user.email, hashed_password, None, "fast_api")
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


@router.get("/id", response_model=schemas.UserOut)
def get_user(
    user_account_id: int,
    db: Session = Depends(get_db),
):
    user = (
        db.query(models.User)
        .filter(models.User.user_account_id == user_account_id)
        .first()
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with id: {id} does not exist",
        )

    return user
