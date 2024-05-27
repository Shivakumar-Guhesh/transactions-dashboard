from fastapi import APIRouter, Depends, HTTPException, Response, status
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlalchemy import select
from sqlalchemy.orm import Session
from sqlalchemy.orm.exc import NoResultFound

from .. import database, models, oauth2, schemas, utils

router = APIRouter(tags=["Authentication"])


@router.post("/login", response_model=schemas.Token)
def login(
    user_credentials: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(database.get_db),
):

    # user = (
    #     db.query(models.User)
    #     .filter(models.User.email == user_credentials.username)
    #     .first()
    # )

    # user = db.execute(select(models.User).filter_by(email=user_credentials.username))
    try:
        user = (
            db.execute(select(models.User).filter_by(email=user_credentials.username))
            .scalars()
            .one()
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail=f"Invalid Credentials"
        )
    if not utils.verify(user_credentials.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail=f"Invalid Credentials"
        )

    # create a token
    # return token

    access_token = oauth2.create_access_token(data={"user_id": user.user_account_id})

    return {"access_token": access_token, "token_type": "bearer"}
