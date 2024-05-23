from time import time

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy import create_engine

DOTENV = "D:\\transactions_dashboard\\data\\.env"


class Settings(BaseSettings):
    database_hostname: str = Field(default="")
    database_name: str = Field(default="")
    database_password: str = Field(default="")
    database_port: str = Field(default="")
    database_type: str = Field(default="")
    database_username: str = Field(default="")
    input_file: str = Field(default="")
    sqlite_database_path: str = Field(default="")

    # class Config:
    #     env_file = ".env"

    # model_config = SettingsConfigDict(
    #     case_sensitive=False, env_file=".env", env_file_encoding="utf-8"
    # )
    model_config = SettingsConfigDict(env_file=DOTENV)
