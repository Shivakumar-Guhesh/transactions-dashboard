from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

from .config import Settings

settings = Settings.model_validate({})


# SQLALCHEMY_DATABASE_URL = f"{settings.database_type}:///{settings.sqlite_database_path}"

if settings.database_type.lower() == "sqlite":
    SQLALCHEMY_DATABASE_URL = f"sqlite:///{settings.sqlite_database_path}"
else:
    SQLALCHEMY_DATABASE_URL = (
        f"{settings.database_type}://{settings.database_username}:{settings.database_password}"
        f"@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"
    )


engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
