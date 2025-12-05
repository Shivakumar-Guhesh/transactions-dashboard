from pydantic_settings import BaseSettings, SettingsConfigDict

DOTENV = "./.env"


class Settings(BaseSettings):

    database_hostname: str
    database_name: str
    database_password: str
    database_port: str
    database_type: str
    database_username: str
    input_file: str
    sqlite_database_path: str

    default_user_id: int = 1
    legacy_date_for_first_run: str = "19000101"

    model_config = SettingsConfigDict(env_file=DOTENV)
