# 📋 ETL Code Review Report

## Summary Score

**Overall Assessment: 72/100 (Good)**

| Category | Score | Status |
|----------|-------|--------|
| Code Quality & Standard Compliance | 70/100 | ⚠️ Moderate Issues |
| Naming Convention Adherence | 85/100 | ✅ Good |
| ETL Best Practices & Architecture | 68/100 | ⚠️ Moderate Issues |
| Security & Performance | 65/100 | ⚠️ Needs Improvement |

**Key Findings:**

- 8 code quality/PEP 8 violations
- 3 naming convention inconsistencies
- 5 architectural/best practice concerns
- 4 security/performance risks
- **Total Issues: 20**

---

## Detailed Findings

### File: `tran_fact_load.py`

#### Code Quality & Standard Compliance

**Issue #1: Line Length Exceeds PEP 8 Limit (79/88 characters)**

- **Severity:** Low
- **Lines:** 37-39, 183
- **Problem:** SQLAlchemy URL construction and other lines exceed 79 characters

```python
# Current (88 chars)
SQLALCHEMY_DATABASE_URL = (
    f"{settings.database_type}://{settings.database_username}:{settings.database_password}"
    f"@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"
)
```

**Issue #2: Variable Naming - EXCESSIVE USE OF UPPERCASE CONSTANTS**

- **Severity:** Medium
- **Lines:** 24-29, 35-51
- **Problem:** Many module-level variables that are not truly "constants" are named in ALL_CAPS, violating PEP 8 style. Should be lowercase with snake_case for configuration/computed values
- **Examples:** `INPUT_FILE`, `CURRENT_DIR`, `CURRENT_DATE_STR`, `DATE_CONTROL_FILE_PATH`, `LOG_FILE_DIR`, `SQLALCHEMY_DATABASE_URL`
- **PEP 8 Guidance:** Constants should be ALL_CAPS; configuration values should be lowercase

**Issue #3: Mutable Default Arguments Risk**

- **Severity:** Low
- **Line:** 180
- **Problem:** Dictionary comprehension in `to_dict(orient="records")` - not a direct mutable default, but list/dict handling could be more explicit

**Issue #4: Inconsistent Comment Formatting**

- **Severity:** Low
- **Lines:** 53-57, 63-65, 86-88, 174-175
- **Problem:** Comment separators use inconsistent styles (equals signs with varying lengths); some comments lack proper spacing

**Issue #5: Unused Import `sys`**

- **Severity:** Low
- **Line:** 8
- **Problem:** `sys` is imported and used for `sys.excepthook` and `sys.exit()`, but should verify all usage

**Issue #6: Bare Exception Handling**

- **Severity:** Medium
- **Lines:** 140-143
- **Problem:** Catching generic `Exception` too broadly in extract_data; should catch specific exceptions

```python
except Exception as e:  # Too broad
    logger.error(f"Failed to read and validate input file. ETL Failed: {e}")
    raise
```

**Issue #7: Type Hints Missing**

- **Severity:** Medium
- **Lines:** Throughout function definitions
- **Problem:** Python 3.6+ features not fully utilized; missing return type hints and parameter annotations

```python
# Current
def setup_logging():
    
# Should be
def setup_logging() -> None:
```

**Issue #8: String Formatting Inconsistency**

- **Severity:** Low
- **Lines:** 94-96, 128-131, various logging statements
- **Problem:** Mix of f-strings and `.format()` calls; should standardize to f-strings (PEP 498)

#### Naming Convention Adherence

**Issue #1: INCONSISTENT CONSTANT NAMING**

- **Severity:** Medium
- **Problem:** Module-level variables that should be lowercase are in UPPERCASE
- **Examples:**
  - `TABLE_NAME = "TRANSACTION_FACT"` → `TABLE_NAME` (constant, but computed at runtime)
  - `CURRENT_DIR`, `CURRENT_DATE_STR`, `DATE_CONTROL_FILE_PATH` → These are derived values, not true constants
  - Should follow: True constants are `ALL_CAPS`; module-level variables are `lowercase_with_underscores`

**Issue #2: Abbreviation Usage**

- **Severity:** Low
- **Lines:** Multiple
- **Problem:** Inconsistent abbreviation patterns
- **Examples:** `INSRT_USER` (INSERT abbreviated), `dt_ctrl.txt` (datetime control abbreviated)
- **Recommendation:** Use full names: `INSERT_USER`, `datetime_control.txt`

**Issue #3: Mixed Naming in Dictionary Keys**

- **Severity:** Low
- **Line:** 43-49
- **Problem:** Dictionary `REQUIRED_EXCEL_COLUMNS_MAP` uses CapWords keys but snake_case is more Pythonic for this context

```python
REQUIRED_EXCEL_COLUMNS_MAP = {
    "Date": "TRANSACTION_DATE",           # CapWords source, UPPER_SNAKE target
    "Transaction": "TRANSACTION",
    ...
}
```

#### ETL Best Practices & Architecture

**Issue #1: Hardcoded Magic Values**

- **Severity:** Medium
- **Line:** 109, 156
- **Problem:** Magic date string `"19000101"` and hardcoded `USER_ID = 1` should be configurable

```python
LAST_PROCESSED_DATE = datetime.datetime.strptime("19000101", DATE_FORMATTER)  # Magic value
tran_fact_df.insert(0, "USER_ID", value=1)  # Hardcoded user ID
```

**Issue #2: Date Control File as Flat File (Scalability)**

- **Severity:** Medium
- **Line:** 107-113, 182-183
- **Problem:** Using a flat text file for date control is not scalable; should use database metadata table
- **Risk:** Race conditions in concurrent scenarios, no audit trail, no backup mechanism

**Issue #3: No Retry Logic or Error Recovery**

- **Severity:** Medium
- **Line:** 168-173
- **Problem:** Database connection failures are not retried; ETL fails immediately without retry attempts
- **Best Practice:** Implement exponential backoff retry logic

**Issue #4: No Data Validation Post-Transform**

- **Severity:** Medium
- **Line:** 154-158
- **Problem:** Transformed data is not validated before loading; missing integrity checks
- **Best Practice:** Add schema validation, null checks, and data quality gates

**Issue #5: Logging Timestamp in Filename**

- **Severity:** Low
- **Line:** 72-74
- **Problem:** Log file naming includes microseconds and timezone, creating many small log files; should aggregate by date

```python
# Current - creates unique file per run
LOG_FILE_PATH = f"{LOG_FILE_DIR}/{log_file_name}_logs_{datetime.datetime.now().strftime(TIMESTAMP_FORMATTER)}.log"
```

---

### File: `config.py`

#### Code Quality & Standard Compliance

**Issue #1: No Validation or Documentation**

- **Severity:** Low
- **Problem:** Settings class has no field validators or documentation
- **Missing:** Field descriptions, validation rules, default values

**Issue #2: Environment Variable Names Not Documented**

- **Severity:** Low
- **Problem:** No indication of required environment variables or their format

#### Naming Convention Adherence

**Status:** ✅ COMPLIANT - All naming follows snake_case conventions properly

#### ETL Best Practices & Architecture

**Issue #1: No Environment Validation at Startup**

- **Severity:** Medium
- **Problem:** Missing required settings are not detected until first use
- **Best Practice:** Validate all settings immediately on import

**Issue #2: Insufficient Configuration for Different Environments**

- **Severity:** Medium
- **Problem:** No environment profiles (dev, test, prod); all configuration is flat

---

### File: `constants.py`

#### Code Quality & Standard Compliance

**Status:** ✅ COMPLIANT - Simple, well-formatted constants file

#### Naming Convention Adherence

**Status:** ✅ COMPLIANT - CONSTANT_CASE properly applied

#### ETL Best Practices & Architecture

**Status:** ✅ ACCEPTABLE - Minimal scope, properly separated

---

### File: `daily_tran_fact_load_task.xml`

#### Code Quality & Standard Compliance

**Issue #1: Hard-coded Absolute Paths**

- **Severity:** Medium
- **Line:** `<Arguments>` and `<WorkingDirectory>`
- **Problem:** `D:\transactions_dashboard\data` and `C:\Windows\System32\cmd.exe` are environment-specific
- **Risk:** Task fails in different environments; not portable

**Issue #2: No Error Handling or Retry Policy**

- **Severity:** Medium
- **Problem:** Task has no `OnTaskFailure` restart policy or retry logic
- **Best Practice:** Should restart on failure with exponential backoff

**Issue #3: Hard-coded Execution Time Limit**

- **Severity:** Low
- **Line:** `<ExecutionTimeLimit>PT72H</ExecutionTimeLimit>`
- **Problem:** 72 hours is excessive; should be more specific (e.g., PT1H)

#### Naming Convention Adherence

**Status:** ✅ COMPLIANT - XML schema compliance

#### ETL Best Practices & Architecture

**Issue #1: Security - Relative Path Traversal**

- **Severity:** Medium
- **Line:** `..\transactions_dashboard_venv\Scripts\python.exe`
- **Problem:** Relative path to venv could be exploited; should use absolute path or environment variable

**Issue #2: No Logging Configuration in Task**

- **Severity:** Medium
- **Problem:** Task has no standard output/error capture; logs only if Python script implements it

---

### File: `tran_fact.sql`

#### Code Quality & Standard Compliance

**Issue #1: Missing Index for Foreign Key**

- **Severity:** Low
- **Line:** 9
- **Problem:** `USER_ID` FOREIGN KEY is not indexed; foreign key lookups will be slow

**Issue #2: No Check Constraint for AMOUNT**

- **Severity:** Medium
- **Problem:** `AMOUNT` FLOAT has no constraint; negative amounts are allowed without validation
- **Recommendation:** Add `CHECK (AMOUNT > 0)` or `CHECK (AMOUNT != 0)`

**Issue #3: Ambiguous Default for CURRENCY**

- **Severity:** Low
- **Line:** 8
- **Problem:** `DEFAULT "INR"` assumes all transactions are in INR; should be configurable or validated

**Issue #4: Missing Audit Columns**

- **Severity:** Low
- **Problem:** No `UPDATE_TS` or `UPDATE_USER` for tracking modifications

#### Naming Convention Adherence

**Status:** ✅ COMPLIANT - Proper UPPER_SNAKE_CASE for table/column names

#### ETL Best Practices & Architecture

**Issue #1: No Partitioning Strategy**

- **Severity:** Medium
- **Problem:** For transaction fact tables, should be partitioned by date for performance
- **Best Practice:** Implement `PARTITION BY RANGE (TRANSACTION_DATE)`

**Issue #2: Missing Surrogate Key Index**

- **Severity:** Low
- **Problem:** Primary key index exists but no covering index for common queries

---

### File: `user_account.sql`

#### Code Quality & Standard Compliance

**Issue #1: EMAIL Validation Regex Too Weak**

- **Severity:** Medium
- **Line:** 4
- **Problem:** `EMAIL LIKE '%@%.%'` is insufficient validation
- **Better:** Use application-layer email validation or regex constraint

**Issue #2: No Password Constraints**

- **Severity:** Medium
- **Problem:** `HASHED_PASSWORD` has no NOT NULL constraint; should be required

**Issue #3: Missing UPDATED_TS Column**

- **Severity:** Low
- **Problem:** No update timestamp tracking

#### Naming Convention Adherence

**Status:** ✅ COMPLIANT - Proper UPPER_SNAKE_CASE for table/column names

#### ETL Best Practices & Architecture

**Issue #1: Role-Based Access Not Implemented**

- **Severity:** Medium
- **Problem:** `ROLE` field exists but no foreign key to permissions table

---

## Recommendations for Resolution

### Code Quality & PEP 8 Compliance

#### 1. **Fix Line Length (PEP 8 - 79 character limit)**

**Before:**

```python
SQLALCHEMY_DATABASE_URL = (
    f"{settings.database_type}://{settings.database_username}:{settings.database_password}"
    f"@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"
)
```

**After:**

```python
sqlalchemy_database_url = (
    f"{settings.database_type}://"
    f"{settings.database_username}:{settings.database_password}"
    f"@{settings.database_hostname}:{settings.database_port}/"
    f"{settings.database_name}"
)
```

#### 2. **Add Type Hints Throughout**

**Before:**

```python
def extract_data():
    """Returns tuple[pd.DataFrame, str]: ..."""
    pass

def transform_data(tran_fact_df: pd.DataFrame) -> pd.DataFrame:
    pass
```

**After:**

```python
def extract_data() -> tuple[pd.DataFrame, str]:
    """Returns filtered data and current process date."""
    pass

def transform_data(tran_fact_df: pd.DataFrame) -> pd.DataFrame:
    """Applies transformations to raw data."""
    pass

def load_data(tran_fact_df: pd.DataFrame, curr_prcs_date: str) -> None:
    """Loads data and updates control file."""
    pass

def setup_logging() -> None:
    """Initializes logging configuration."""
    pass

def handle_unhandled_exception(
    exc_type: type[BaseException],
    exc_value: BaseException,
    exc_traceback: types.TracebackType | None
) -> None:
    """Logs unhandled exceptions."""
    pass
```

#### 3. **Fix Variable Naming (Configuration vs Constants)**

**Before:**

```python
INPUT_FILE = settings.input_file
TABLE_NAME = "TRANSACTION_FACT"
CURRENT_DIR = os.path.dirname(__file__)
CURRENT_DATE_STR = datetime.datetime.now().strftime(DATE_FORMATTER)
DATE_CONTROL_FILE_PATH = os.path.join(CURRENT_DIR, "dt_ctrl.txt")
```

**After:**

```python
# True constants (unchanged at runtime)
TABLE_NAME = "TRANSACTION_FACT"
DEFAULT_LEGACY_DATE = "19000101"

# Configuration/derived values (lowercase)
input_file = settings.input_file
current_dir = os.path.dirname(__file__)
current_date_str = datetime.datetime.now().strftime(DATE_FORMATTER)
date_control_file_path = os.path.join(current_dir, "dt_ctrl.txt")
log_file_dir = os.path.join(current_dir, "logs")
```

#### 4. **Replace Generic Exception Handling with Specific Exceptions**

**Before:**

```python
try:
    input_df = pd.read_excel(INPUT_FILE, index_col=None)
    logger.info(f"Read {input_df.shape[0]} records from source file: {INPUT_FILE}")
    missing_cols = REQUIRED_EXCEL_COLUMNS - set(input_df.columns)
    if missing_cols:
        raise ValueError(f"Missing required columns: {missing_cols}")
except Exception as e:
    logger.error(f"Failed to read and validate input file. ETL Failed: {e}")
    raise
```

**After:**

```python
try:
    input_df = pd.read_excel(input_file, index_col=None)
    logger.info(
        f"Read {input_df.shape[0]} records from source file: {input_file}"
    )
    missing_cols = REQUIRED_EXCEL_COLUMNS - set(input_df.columns)
    if missing_cols:
        raise ValueError(
            f"Missing required columns: {missing_cols}"
        )
except FileNotFoundError as e:
    logger.error(f"Input file not found: {input_file}")
    raise
except (ValueError, KeyError) as e:
    logger.error(f"Data validation failed: {e}")
    raise
except Exception as e:
    logger.error(f"Unexpected error reading input file: {e}")
    raise
```

#### 5. **Standardize String Formatting to f-strings**

**Before:**

```python
logger.info(
    f"Reading records later than {LAST_PROCESSED_DATE.strftime(DATE_FORMATTER)} and less than {CURRENT_DATE_STR}"
)
```

**After:** (Already using f-strings, but ensure consistency throughout)

#### 6. **Improve Comment Formatting**

**Before:**

```python
# ============================================================================ #
#                                   CONSTANTS                                  #
# ============================================================================ #
```

**After:**

```python
# ========================================================================== #
#                              MODULE CONSTANTS                             #
# ========================================================================== #
```

---

### Performance & Architecture

#### 1. **Replace Flat File Date Control with Database Metadata Table**

**Create metadata table:**

```sql
CREATE TABLE IF NOT EXISTS ETL_CONTROL (
    CONTROL_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    PROCESS_NAME TEXT NOT NULL UNIQUE,
    LAST_PROCESSED_DATE DATE NOT NULL,
    LAST_RUN_TIMESTAMP DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    STATUS TEXT DEFAULT 'SUCCESS' NOT NULL
);
```

**Updated Python code:**

```python
def get_last_processed_date(engine: Engine, process_name: str) -> datetime.datetime:
    """Retrieves last processed date from database metadata."""
    query = "SELECT LAST_PROCESSED_DATE FROM ETL_CONTROL WHERE PROCESS_NAME = ?"
    with engine.connect() as conn:
        result = conn.execute(query, [process_name]).fetchone()
    
    if result is None:
        return datetime.datetime.strptime(DEFAULT_LEGACY_DATE, DATE_FORMATTER)
    return result[0]

def update_last_processed_date(
    engine: Engine,
    process_name: str,
    new_date: str
) -> None:
    """Updates last processed date in database metadata."""
    upsert_query = """
    INSERT INTO ETL_CONTROL (PROCESS_NAME, LAST_PROCESSED_DATE, STATUS)
    VALUES (?, ?, 'SUCCESS')
    ON CONFLICT(PROCESS_NAME) DO UPDATE SET
        LAST_PROCESSED_DATE = excluded.LAST_PROCESSED_DATE,
        LAST_RUN_TIMESTAMP = CURRENT_TIMESTAMP
    """
    with engine.begin() as conn:
        conn.execute(upsert_query, [process_name, new_date])
```

#### 2. **Add Retry Logic with Exponential Backoff**

**Before:**

```python
engine = create_engine(SQLALCHEMY_DATABASE_URL)
```

**After:**

```python
def create_engine_with_retry(
    database_url: str,
    max_retries: int = 3,
    initial_delay: float = 1.0
) -> Engine:
    """Creates SQLAlchemy engine with retry logic."""
    import time
    
    for attempt in range(max_retries):
        try:
            engine = create_engine(
                database_url,
                connect_args={"timeout": 10}
            )
            # Test connection
            with engine.connect() as conn:
                conn.execute("SELECT 1")
            logger.info(f"Database connection established (attempt {attempt + 1})")
            return engine
        except Exception as e:
            if attempt == max_retries - 1:
                raise
            delay = initial_delay * (2 ** attempt)
            logger.warning(
                f"Database connection failed (attempt {attempt + 1}). "
                f"Retrying in {delay}s. Error: {e}"
            )
            time.sleep(delay)
```

#### 3. **Add Data Quality Validation Post-Transform**

**After:**

```python
def validate_transformed_data(
    df: pd.DataFrame,
    required_columns: set[str]
) -> bool:
    """Validates transformed data before loading."""
    # Check for required columns
    missing_cols = required_columns - set(df.columns)
    if missing_cols:
        logger.error(f"Missing required columns after transform: {missing_cols}")
        return False
    
    # Check for null values in critical columns
    critical_columns = [
        "TRANSACTION_DATE", "AMOUNT", "CATEGORY", "TRANSACTION_TYPE"
    ]
    nulls = df[critical_columns].isnull().sum()
    if nulls.any():
        logger.error(f"Null values found in critical columns:\n{nulls}")
        return False
    
    # Check for invalid amounts
    if (df["AMOUNT"] <= 0).any():
        logger.error("Found zero or negative amounts")
        return False
    
    # Check for future dates
    if (df["TRANSACTION_DATE"] > datetime.datetime.now().date()).any():
        logger.error("Found future transaction dates")
        return False
    
    logger.info("Data validation passed")
    return True
```

**Usage in transform_data:**

```python
def transform_data(tran_fact_df: pd.DataFrame) -> pd.DataFrame:
    """Applies transformations and validates data."""
    transform_start_time = datetime.datetime.now()
    
    # ... existing transformations ...
    
    # Validate before returning
    required_cols = {
        "USER_ID", "TRANSACTION_DATE", "AMOUNT", 
        "CATEGORY", "TRANSACTION_TYPE"
    }
    if not validate_transformed_data(tran_fact_df, required_cols):
        raise ValueError("Data validation failed post-transform")
    
    transform_duration = (
        datetime.datetime.now() - transform_start_time
    ).total_seconds()
    logger.info(f"Transform Stage completed in {transform_duration:.2f} seconds.")
    
    return tran_fact_df
```

#### 4. **Improve Log File Management**

**Before:**

```python
LOG_FILE_PATH = f"{LOG_FILE_DIR}/{log_file_name}_logs_{datetime.datetime.now().strftime(TIMESTAMP_FORMATTER)}.log"
```

**After:**

```python
def get_log_file_path(log_dir: str, process_name: str) -> str:
    """Generates log file path using date (not timestamp) for aggregation."""
    log_date = datetime.datetime.now().strftime("%Y%m%d")
    log_file = f"{log_dir}/{process_name}_logs_{log_date}.log"
    return log_file

LOG_FILE_PATH = get_log_file_path(log_file_dir, "tran_fact_load")
```

This ensures all logs from the same day are aggregated in one file.

#### 5. **Make Hardcoded Values Configurable**

**Before:**

```python
tran_fact_df.insert(0, "USER_ID", value=1)
```

**After:**

```python
class Settings(BaseSettings):
    # ... existing settings ...
    default_user_id: int = 1
    legacy_date_for_first_run: str = "19000101"

# In main code
tran_fact_df.insert(0, "USER_ID", value=settings.default_user_id)
```

---

### Naming Convention Adherence

#### 1. **Standardize Abbreviations**

**Before:**

```python
# In code
INSRT_USER = "ETL_MGR"
# In filename
dt_ctrl.txt
```

**After:**

```python
# In code
insert_user = "ETL_MGR"
# In filename
date_control.txt
```

#### 2. **Consistent Dictionary Key Naming**

**Before:**

```python
REQUIRED_EXCEL_COLUMNS_MAP = {
    "Date": "TRANSACTION_DATE",
    "Transaction": "TRANSACTION",
}
```

**After:** (Keep as-is if source column names are from Excel)

```python
# Source columns are from Excel headers (cannot change)
# But rename the constant for clarity:
source_to_target_columns = {
    "Date": "TRANSACTION_DATE",
    "Transaction": "TRANSACTION",
    # ...
}
```

#### 3. **Update XML Task File Path References**

**Before:**

```xml
<Command>C:\Windows\System32\cmd.exe</Command>
<Arguments>..\transactions_dashboard_venv\Scripts\python.exe -m etl.tran_fact_load</Arguments>
<WorkingDirectory>D:\transactions_dashboard\data</WorkingDirectory>
```

**After:**

```xml
<Command>C:\Windows\System32\cmd.exe</Command>
<Arguments>%VENV_PATH%\Scripts\python.exe -m data.etl.tran_fact_load</Arguments>
<WorkingDirectory>%PROJECT_ROOT%</WorkingDirectory>
```

Or better, use environment variables or a batch wrapper script.

---

## Summary of Priority Actions

### 🔴 Critical (Address Immediately)

1. Add data validation post-transform
2. Replace flat-file date control with database metadata
3. Implement retry logic for database connections
4. Fix security issues in XML task (hard-coded paths)
5. Add CHECK constraint for AMOUNT in TRANSACTION_FACT table

### 🟠 High (Address in Next Sprint)

1. Add type hints to all functions
2. Replace generic exception handling with specific exceptions
3. Fix constant naming (separate true constants from configuration)
4. Add email validation constraints in USER_ACCOUNT table
5. Remove magic hardcoded values (user_id, legacy date)

### 🟡 Medium (Address Within 2 Sprints)

1. Improve comment formatting consistency
2. Add environment profiles for dev/test/prod
3. Implement log file aggregation by date
4. Add password NOT NULL constraint
5. Add audit columns (UPDATE_TS, UPDATE_USER) to tables

### 🟢 Low (Nice to Have)

1. Standardize string formatting (all f-strings)
2. Reduce execution time limit in task XML
3. Add role-based access control structure
4. Implement transaction fact table partitioning

---

## Code Examples Summary

All refactored code snippets have been provided above with:

- Type hints for all functions
- Specific exception handling
- Proper variable naming conventions
- Database metadata table for control files
- Retry logic with exponential backoff
- Data validation functions
- Improved error messages and logging

**Next Steps:**

1. Review this report with the development team
2. Prioritize fixes based on impact and effort
3. Create tickets for each critical/high-priority item
4. Implement and test changes in a development environment
5. Update configuration management and deployment processes
