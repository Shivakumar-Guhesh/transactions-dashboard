from pydantic_settings import BaseSettings, SettingsConfigDict

DOTENV = ".env"


class Settings(BaseSettings):
    # database_hostname: str = Field(default="")
    # database_name: str = Field(default="")
    # database_password: str = Field(default="")
    # database_port: str = Field(default="")
    # database_type: str = Field(default="")
    # database_username: str = Field(default="")
    # input_file: str = Field(default="")
    # sqlite_database_path: str = Field(default="")

    database_hostname: str
    database_name: str
    database_password: str
    database_port: str
    database_type: str
    database_username: str
    input_file: str
    sqlite_database_path: str

    model_config = SettingsConfigDict(env_file=DOTENV)
