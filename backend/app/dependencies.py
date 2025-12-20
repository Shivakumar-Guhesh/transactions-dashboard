from fastapi import Depends
from sqlalchemy.orm import Session

from .config import Settings
from .database import get_db
from .repositories.llm_repository import LlmRepository
from .repositories.transaction_repository import TransactionRepository
from .repositories.user_repository import UserRepository
from .services.auth_service import AuthService
from .services.llm_service import LlmService
from .services.transaction_service import TransactionService
from .services.user_service import UserService

settings = Settings.model_validate({})


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


def get_llm_repository() -> LlmRepository:
    """
    Dependency function to get a LlmRepository instance.
    """
    db_path = settings.chroma_db_path
    collection_name = "transactions_collection"
    return LlmRepository(db_path=db_path, collection_name=collection_name)


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


def get_llm_service(
    llm_repository: LlmRepository = Depends(get_llm_repository),
    transaction_repository: TransactionRepository = Depends(get_transaction_repository),
) -> LlmService:
    """
    Dependency function to get a LlmService instance
    with repositories injected.
    """
    return LlmService(
        llm_repository=llm_repository, transaction_repository=transaction_repository
    )
