from fastapi import Depends
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlalchemy.orm.exc import NoResultFound

from .. import models, oauth2, utils
from ..repositories.user_repository import UserRepository
from ..schemas.auth_schemas import TokenResponse


class AuthService:
    """Handles business logic related to authentication.

    Args:
        repository (UserRepository): An instance of UserRepository.
    """

    def __init__(self, repository: UserRepository) -> None:
        self.repository = repository

    def authenticate_user(
        self,
        username: str,
        password: str,
    ) -> TokenResponse:
        try:
            user = self.repository.get_user_by_email(username)
            if not utils.verify(password, user.hashed_password):
                raise NoResultFound
            # return user
        except NoResultFound:
            raise NoResultFound

        access_token = oauth2.create_access_token(data={"user_id": user.user_id})
        return TokenResponse.model_validate(
            {"access_token": access_token, "token_type": "bearer"}
        )
