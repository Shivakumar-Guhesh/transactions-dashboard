from fastapi import Depends
from sqlalchemy.orm import Session

from .database import get_db
from .repositories.transaction_repository import TransactionRepository
from .repositories.user_repository import UserRepository
from .services.auth_service import AuthService
from .services.transaction_service import TransactionService
from .services.user_service import UserService


def get_transaction_repository(db: Session = Depends(get_db)) -> TransactionRepository:
    """
    Dependency function to get a TransactionRepository instance
    with a database session injected.
    """
    return TransactionRepository(db)


def get_transaction_service(
    repository: TransactionRepository = Depends(get_transaction_repository),
) -> TransactionService:
    """
    Dependency function to get a TransactionService instance
    with a TransactionRepository injected.
    """
    return TransactionService(repository)


def get_user_repository(db: Session = Depends(get_db)) -> UserRepository:
    """
    Dependency function to get a UserRepository instance
    with a database session injected.
    """
    return UserRepository(db)


def get_user_service(
    repository: UserRepository = Depends(get_user_repository),
) -> UserService:
    """
    Dependency function to get a TransactionService instance
    with a TransactionRepository injected.
    """
    return UserService(repository)


def get_auth_service(
    repository: UserRepository = Depends(get_user_repository),
) -> AuthService:
    """
    Dependency function to get a TransactionService instance
    with a TransactionRepository injected.
    """
    return AuthService(repository)
