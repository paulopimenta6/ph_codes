from __future__ import annotations

import numpy as np
import pandas as pd


def _ensure_monthly_index(df: pd.DataFrame) -> pd.DataFrame:
    out = df.copy()
    out["date"] = pd.to_datetime(out["date"], errors="coerce")
    out = out.dropna(subset=["date"]).sort_values("date").drop_duplicates(subset=["date"], keep="last")
    return out.reset_index(drop=True)


def remove_outliers_iqr(df: pd.DataFrame, cols: list[str]) -> pd.DataFrame:
    out = df.copy()
    for col in cols:
        if col not in out.columns:
            continue
        s = pd.to_numeric(out[col], errors="coerce")
        q1, q3 = s.quantile(0.25), s.quantile(0.75)
        iqr = q3 - q1
        if pd.isna(iqr) or iqr == 0:
            continue
        lo, hi = q1 - 1.5 * iqr, q3 + 1.5 * iqr
        out.loc[(s < lo) | (s > hi), col] = np.nan
    return out


def winsorize_series(s: pd.Series, lower_q: float = 0.01, upper_q: float = 0.99) -> pd.Series:
    s = pd.to_numeric(s, errors="coerce")
    if s.dropna().empty:
        return s
    return s.clip(s.quantile(lower_q), s.quantile(upper_q))


def add_time_features(df: pd.DataFrame) -> pd.DataFrame:
    out = df.copy()
    out["year"] = out["date"].dt.year
    out["month"] = out["date"].dt.month
    out["quarter"] = out["date"].dt.quarter
    out["month_name"] = out["date"].dt.month_name()
    out["period"] = out["date"].dt.to_period("M").astype(str)
    return out


def _add_growth_features(df: pd.DataFrame, cols: list[str]) -> pd.DataFrame:
    out = df.copy()
    for col in cols:
        out[f"{col}_mom"] = out[col].pct_change()
        out[f"{col}_yoy"] = out[col].pct_change(12)
        out[f"{col}_ma3"] = out[col].rolling(3, min_periods=1).mean()
        out[f"{col}_ma12"] = out[col].rolling(12, min_periods=1).mean()
        out[f"{col}_vol12"] = out[col].rolling(12, min_periods=4).std()
        out[f"log_{col}"] = np.log(out[col].clip(lower=1))
    return out


def clean_trade_data(df: pd.DataFrame) -> pd.DataFrame:
    clean = _ensure_monthly_index(df)
    for col in ["exports", "imports", "balance"]:
        clean[col] = pd.to_numeric(clean[col], errors="coerce")

    clean = remove_outliers_iqr(clean, ["exports", "imports", "balance"])
    clean[["exports", "imports", "balance"]] = (
        clean[["exports", "imports", "balance"]]
        .interpolate(method="linear", limit_direction="both")
        .ffill()
        .bfill()
    )

    clean["balance"] = clean["exports"] - clean["imports"]
    clean = add_time_features(clean)
    clean = _add_growth_features(clean, ["exports", "imports", "balance"])

    clean["coverage_ratio"] = np.where(clean["imports"] != 0, clean["exports"] / clean["imports"] * 100, np.nan)
    clean["trade_growth_spread"] = clean["exports_yoy"] - clean["imports_yoy"]
    clean["exports_minus_imports_abs"] = clean["balance"].abs()
    clean["log_balance"] = np.sign(clean["balance"]) * np.log1p(clean["balance"].abs())
    clean["rolling_trade_gap_12"] = clean["balance"].rolling(12, min_periods=4).mean()

    return clean.reset_index(drop=True)


def clean_macro_data(df: pd.DataFrame) -> pd.DataFrame:
    clean = df.copy()
    clean["date"] = pd.to_datetime(clean["date"], errors="coerce")
    clean = clean.dropna(subset=["date", "indicator"]).sort_values(["indicator", "date"])
    clean["value"] = pd.to_numeric(clean["value"], errors="coerce")
    clean["year"] = clean["date"].dt.year
    clean["quarter"] = clean["date"].dt.quarter
    return clean.reset_index(drop=True)
