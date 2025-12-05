from sqlalchemy.orm.exc import NoResultFound

from .. import models, utils
from ..repositories.user_repository import UserRepository
from ..schemas import user_schemas


class UserService:
    """Handles business logic related to user data.

    Args:
        repository (UserRepository): An instance of UserRepository.
    """

    def __init__(self, repository: UserRepository) -> None:
        self.repository = repository

    def create_user(
        self,
        user: user_schemas.UserCreateRequest,
    ) -> models.User:
        hashed_password = utils.hash(user.password)
        return self.repository.insert_user(
            email=user.email,
            hashed_password=hashed_password,
            insrt_user="fast_api",
        )

    def get_user_by_id(self, user_id: int) -> models.User | None:
        return self.repository.get_user_by_id(user_id)

    def get_user_by_email(self, email: str) -> models.User:
        try:
            return self.repository.get_user_by_email(email)
        except NoResultFound:
            raise NoResultFound
