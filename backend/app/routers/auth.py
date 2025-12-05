from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlalchemy.orm.exc import NoResultFound

from .. import oauth2, utils
from ..dependencies import get_auth_service, get_user_service
from ..schemas import auth_schemas
from ..services.auth_service import AuthService

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post(
    "/login", status_code=status.HTTP_200_OK, response_model=auth_schemas.TokenResponse
)
def login(
    user_credentials: OAuth2PasswordRequestForm = Depends(),
    service: AuthService = Depends(get_auth_service),
):

    try:
        return service.authenticate_user(
            user_credentials.username, user_credentials.password
        )
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail=f"Invalid Credentials"
        )
