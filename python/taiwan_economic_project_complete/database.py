from __future__ import annotations

import json
import sqlite3
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path

import pandas as pd

SCHEMA = """
PRAGMA journal_mode=WAL;

CREATE TABLE IF NOT EXISTS trade_data (
    date TEXT PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    month_name TEXT,
    period TEXT,
    exports REAL,
    imports REAL,
    balance REAL,
    exports_mom REAL,
    exports_yoy REAL,
    exports_ma3 REAL,
    exports_ma12 REAL,
    exports_vol12 REAL,
    imports_mom REAL,
    imports_yoy REAL,
    imports_ma3 REAL,
    imports_ma12 REAL,
    imports_vol12 REAL,
    balance_mom REAL,
    balance_yoy REAL,
    balance_ma3 REAL,
    balance_ma12 REAL,
    balance_vol12 REAL,
    coverage_ratio REAL,
    trade_growth_spread REAL,
    exports_minus_imports_abs REAL,
    log_exports REAL,
    log_imports REAL,
    log_balance REAL,
    rolling_trade_gap_12 REAL,
    anomaly_score REAL,
    is_anomaly INTEGER,
    cluster INTEGER,
    source TEXT,
    created_at TEXT,
    updated_at TEXT
);

CREATE TABLE IF NOT EXISTS macro_data (
    indicator TEXT,
    date TEXT,
    year INTEGER,
    quarter INTEGER,
    value REAL,
    unit TEXT,
    frequency TEXT,
    source TEXT,
    fetched_at TEXT,
    created_at TEXT,
    updated_at TEXT,
    PRIMARY KEY (indicator, date, source)
);

CREATE TABLE IF NOT EXISTS analysis_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    analysis_name TEXT NOT NULL,
    analysis_value TEXT NOT NULL,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS execution_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    execution_date TEXT NOT NULL,
    data_source TEXT NOT NULL,
    records_count INTEGER NOT NULL,
    status TEXT NOT NULL,
    message TEXT
);
"""



def _jsonable(obj):
    """Convert common pandas/numpy objects into JSON-friendly Python types."""
    if isinstance(obj, dict):
        return {str(k): _jsonable(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [_jsonable(v) for v in obj]
    if isinstance(obj, tuple):
        return [_jsonable(v) for v in obj]
    if isinstance(obj, set):
        return [_jsonable(v) for v in obj]
    if isinstance(obj, pd.Timestamp):
        return obj.isoformat()
    if hasattr(obj, "isoformat") and not isinstance(obj, (str, bytes)):
        try:
            return obj.isoformat()
        except Exception:
            pass
    if pd.isna(obj):
        return None
    try:
        import numpy as np
        if isinstance(obj, (np.integer, np.floating)):
            return obj.item()
        if isinstance(obj, np.ndarray):
            return obj.tolist()
    except Exception:
        pass
    return obj


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


@contextmanager
def connect_db(db_path: str | Path):
    db_path = Path(db_path)
    ensure_parent(db_path)
    conn = sqlite3.connect(db_path)
    try:
        conn.execute("PRAGMA foreign_keys = ON;")
        yield conn
        conn.commit()
    finally:
        conn.close()


def init_db(db_path: str | Path) -> None:
    with connect_db(db_path) as conn:
        conn.executescript(SCHEMA)


def _now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")


def upsert_trade_data(db_path: str | Path, df: pd.DataFrame, source: str) -> None:
    if df.empty:
        return
    now = _now()
    with connect_db(db_path) as conn:
        rows = []
        for _, row in df.iterrows():
            rows.append(
                (
                    pd.to_datetime(row["date"]).strftime("%Y-%m-%d"),
                    int(row["year"]),
                    int(row["month"]),
                    int(row["quarter"]),
                    row.get("month_name"),
                    row.get("period"),
                    float(row["exports"]) if pd.notna(row.get("exports")) else None,
                    float(row["imports"]) if pd.notna(row.get("imports")) else None,
                    float(row["balance"]) if pd.notna(row.get("balance")) else None,
                    row.get("exports_mom"),
                    row.get("exports_yoy"),
                    row.get("exports_ma3"),
                    row.get("exports_ma12"),
                    row.get("exports_vol12"),
                    row.get("imports_mom"),
                    row.get("imports_yoy"),
                    row.get("imports_ma3"),
                    row.get("imports_ma12"),
                    row.get("imports_vol12"),
                    row.get("balance_mom"),
                    row.get("balance_yoy"),
                    row.get("balance_ma3"),
                    row.get("balance_ma12"),
                    row.get("balance_vol12"),
                    row.get("coverage_ratio"),
                    row.get("trade_growth_spread"),
                    row.get("exports_minus_imports_abs"),
                    row.get("log_exports"),
                    row.get("log_imports"),
                    row.get("log_balance"),
                    row.get("rolling_trade_gap_12"),
                    row.get("anomaly_score"),
                    int(bool(row.get("is_anomaly", False))),
                    int(row.get("cluster")) if pd.notna(row.get("cluster")) else None,
                    source,
                    now,
                    now,
                )
            )

        conn.executemany(
            """
            INSERT INTO trade_data (
                date, year, month, quarter, month_name, period,
                exports, imports, balance,
                exports_mom, exports_yoy, exports_ma3, exports_ma12, exports_vol12,
                imports_mom, imports_yoy, imports_ma3, imports_ma12, imports_vol12,
                balance_mom, balance_yoy, balance_ma3, balance_ma12, balance_vol12,
                coverage_ratio, trade_growth_spread, exports_minus_imports_abs,
                log_exports, log_imports, log_balance, rolling_trade_gap_12,
                anomaly_score, is_anomaly, cluster, source, created_at, updated_at
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(date) DO UPDATE SET
                year=excluded.year,
                month=excluded.month,
                quarter=excluded.quarter,
                month_name=excluded.month_name,
                period=excluded.period,
                exports=excluded.exports,
                imports=excluded.imports,
                balance=excluded.balance,
                exports_mom=excluded.exports_mom,
                exports_yoy=excluded.exports_yoy,
                exports_ma3=excluded.exports_ma3,
                exports_ma12=excluded.exports_ma12,
                exports_vol12=excluded.exports_vol12,
                imports_mom=excluded.imports_mom,
                imports_yoy=excluded.imports_yoy,
                imports_ma3=excluded.imports_ma3,
                imports_ma12=excluded.imports_ma12,
                imports_vol12=excluded.imports_vol12,
                balance_mom=excluded.balance_mom,
                balance_yoy=excluded.balance_yoy,
                balance_ma3=excluded.balance_ma3,
                balance_ma12=excluded.balance_ma12,
                balance_vol12=excluded.balance_vol12,
                coverage_ratio=excluded.coverage_ratio,
                trade_growth_spread=excluded.trade_growth_spread,
                exports_minus_imports_abs=excluded.exports_minus_imports_abs,
                log_exports=excluded.log_exports,
                log_imports=excluded.log_imports,
                log_balance=excluded.log_balance,
                rolling_trade_gap_12=excluded.rolling_trade_gap_12,
                anomaly_score=excluded.anomaly_score,
                is_anomaly=excluded.is_anomaly,
                cluster=excluded.cluster,
                source=excluded.source,
                updated_at=excluded.updated_at
            """,
            rows,
        )


def upsert_macro_data(db_path: str | Path, df: pd.DataFrame, source_default: str = "world_bank") -> None:
    if df.empty:
        return
    now = _now()
    with connect_db(db_path) as conn:
        rows = []
        for _, row in df.iterrows():
            rows.append(
                (
                    row["indicator"],
                    pd.to_datetime(row["date"]).strftime("%Y-%m-%d"),
                    int(row["year"]),
                    int(row["quarter"]),
                    float(row["value"]) if pd.notna(row["value"]) else None,
                    row.get("unit"),
                    row.get("frequency"),
                    row.get("source", source_default),
                    now,
                    now,
                    now,
                )
            )
        conn.executemany(
            """
            INSERT INTO macro_data (
                indicator, date, year, quarter, value, unit, frequency, source,
                fetched_at, created_at, updated_at
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(indicator, date, source) DO UPDATE SET
                year=excluded.year,
                quarter=excluded.quarter,
                value=excluded.value,
                unit=excluded.unit,
                frequency=excluded.frequency,
                fetched_at=excluded.fetched_at,
                updated_at=excluded.updated_at
            """,
            rows,
        )


def save_analysis_result(db_path: str | Path, analysis_name: str, value) -> None:
    payload = value if isinstance(value, str) else json.dumps(_jsonable(value), ensure_ascii=False, default=str)
    with connect_db(db_path) as conn:
        conn.execute(
            "INSERT INTO analysis_results (analysis_name, analysis_value, created_at) VALUES (?, ?, ?)",
            (analysis_name, payload, _now()),
        )


def log_execution(db_path: str | Path, data_source: str, records_count: int, status: str, message: str = "") -> None:
    with connect_db(db_path) as conn:
        conn.execute(
            "INSERT INTO execution_log (execution_date, data_source, records_count, status, message) VALUES (?, ?, ?, ?, ?)",
            (_now(), data_source, int(records_count), status, message),
        )


def load_trade_data(db_path: str | Path) -> pd.DataFrame:
    try:
        with sqlite3.connect(db_path) as conn:
            df = pd.read_sql_query("SELECT * FROM trade_data ORDER BY date", conn)
    except Exception:
        return pd.DataFrame()
    if not df.empty:
        df["date"] = pd.to_datetime(df["date"], errors="coerce")
    return df


def load_macro_data(db_path: str | Path) -> pd.DataFrame:
    try:
        with sqlite3.connect(db_path) as conn:
            df = pd.read_sql_query("SELECT * FROM macro_data ORDER BY indicator, date", conn)
    except Exception:
        return pd.DataFrame()
    if not df.empty:
        df["date"] = pd.to_datetime(df["date"], errors="coerce")
    return df


def load_analysis_results(db_path: str | Path) -> pd.DataFrame:
    try:
        with sqlite3.connect(db_path) as conn:
            df = pd.read_sql_query("SELECT * FROM analysis_results ORDER BY id DESC", conn)
    except Exception:
        return pd.DataFrame()
    return df


def load_execution_log(db_path: str | Path) -> pd.DataFrame:
    try:
        with sqlite3.connect(db_path) as conn:
            df = pd.read_sql_query("SELECT * FROM execution_log ORDER BY id DESC", conn)
    except Exception:
        return pd.DataFrame()
    return df
