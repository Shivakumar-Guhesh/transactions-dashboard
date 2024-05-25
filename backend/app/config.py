from pydantic_settings import BaseSettings, SettingsConfigDict

DOTENV = ".env"


class Settings(BaseSettings):
    access_token_expire_minutes: int
    algorithm: str
    database_hostname: str
    database_name: str
    database_password: str
    database_port: str
    database_type: str
    database_username: str
    secret_key: str
    sqlite_database_path: str

    model_config = SettingsConfigDict(env_file=DOTENV)
