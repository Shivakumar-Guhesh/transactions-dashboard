import datetime
import logging
import os
import sys
from pathlib import Path

from .constants import TIMESTAMP_FORMATTER

# The logger instance to be used everywhere
logger = logging.getLogger(__name__)


def setup_logging(current_dir: str) -> None:
    """
    Initializes the logger and sets up the file handler.
    """
    LOG_FILE_DIR = os.path.join(current_dir, "logs")
    Path(LOG_FILE_DIR).mkdir(parents=True, exist_ok=True)

    log_file_name = Path(sys.argv[0]).stem
    LOG_FILE_PATH = f"{LOG_FILE_DIR}/{log_file_name}_logs_{datetime.datetime.now().strftime(TIMESTAMP_FORMATTER)}.log"

    # Create file handler and set formatter
    file_handler = logging.FileHandler(LOG_FILE_PATH)
    log_format = logging.Formatter(
        "[%(asctime)s] [%(levelname)8s] [%(filename)18s:%(lineno)-4d] --- %(message)s",
        "%Y-%m-%d %H:%M:%S",
    )

    file_handler.setFormatter(log_format)

    # Configure the logger instance
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)
    logger.info(f"Initialized logging")


def handle_unhandled_exception(exc_type, exc_value, exc_traceback) -> None:
    """Logs unhandled exceptions before calling the default excepthook."""
    # Prevent infinite recursion if logger fails
    if logger.handlers:
        if issubclass(exc_type, KeyboardInterrupt):
            sys.__excepthook__(exc_type, exc_value, exc_traceback)
            return

        logger.critical(
            "Unhandled exception caught. Shutting down.",
            exc_info=(exc_type, exc_value, exc_traceback),
        )
    else:
        sys.__excepthook__(exc_type, exc_value, exc_traceback)


# Set the custom exception hook immediately
sys.excepthook = handle_unhandled_exception
