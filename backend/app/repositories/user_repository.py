from sqlalchemy import select
from sqlalchemy.orm import Session

from .. import models


class UserRepository:
    """Handles database operations related to user data.

    Args:
        db (Session): SQLAlchemy Session object.
    """

    def __init__(self, db: Session) -> None:
        self.db = db

    def insert_user(
        self, email: str, hashed_password: str, insrt_user: str
    ) -> models.User:
        new_user = models.User(email, hashed_password, None, insrt_user)
        self.db.add(new_user)
        self.db.commit()
        self.db.refresh(new_user)
        return new_user

    def get_user_by_id(self, user_id: int) -> models.User | None:
        user = (
            self.db.execute(select(models.User).filter_by(user_id=user_id))
            .scalars()
            .one()
        )
        return user

    def get_user_by_email(self, email: str) -> models.User:
        user = (
            self.db.execute(select(models.User).filter_by(email=email)).scalars().one()
        )
        return user
