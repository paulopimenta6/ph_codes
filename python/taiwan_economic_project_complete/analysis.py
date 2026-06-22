from __future__ import annotations

import json
import warnings
from dataclasses import dataclass
from typing import Optional

import numpy as np
import pandas as pd
from scipy import stats
from scipy.stats import jarque_bera, shapiro
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.ensemble import IsolationForest
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler

try:
    from statsmodels.tsa.seasonal import seasonal_decompose
    from statsmodels.tsa.stattools import adfuller, kpss
    from statsmodels.tsa.statespace.sarimax import SARIMAX
except Exception:  # pragma: no cover
    seasonal_decompose = None
    adfuller = None
    kpss = None
    SARIMAX = None


@dataclass
class AnalysisPack:
    descriptive: dict
    correlations: dict
    stationarity: dict
    trend: dict
    anomaly_summary: dict
    monthly_seasonality: dict
    macro_snapshot: dict
    forecast: dict


def _finite_series(s: pd.Series) -> pd.Series:
    return pd.to_numeric(s, errors="coerce").replace([np.inf, -np.inf], np.nan).dropna()


def descriptive_stats(df: pd.DataFrame) -> dict:
    cols = [c for c in ["exports", "imports", "balance"] if c in df.columns]
    out = {}
    for col in cols:
        s = _finite_series(df[col])
        if s.empty:
            continue
        out[col] = {
            "count": int(s.count()),
            "mean": float(s.mean()),
            "median": float(s.median()),
            "std": float(s.std(ddof=1)),
            "min": float(s.min()),
            "q25": float(s.quantile(0.25)),
            "q75": float(s.quantile(0.75)),
            "max": float(s.max()),
            "skew": float(stats.skew(s)) if len(s) > 2 else None,
            "kurtosis": float(stats.kurtosis(s)) if len(s) > 3 else None,
            "cv": float(s.std(ddof=1) / s.mean()) if s.mean() not in (0, np.nan) else None,
        }
    return out


def correlations(df: pd.DataFrame) -> dict:
    cols = [c for c in ["exports", "imports", "balance", "coverage_ratio", "trade_growth_spread"] if c in df.columns]
    if len(cols) < 2:
        return {}
    corr = df[cols].corr(numeric_only=True).round(4).fillna(0)
    return corr.to_dict()


def stationarity_tests(df: pd.DataFrame) -> dict:
    res = {}
    for col in ["exports", "imports", "balance"]:
        if col not in df.columns:
            continue
        series = _finite_series(df[col])
        if len(series) < 12:
            continue
        item = {"shapiro_p": None, "jarque_bera_p": None, "adf_p": None, "kpss_p": None}
        if len(series) <= 5000:
            try:
                item["shapiro_p"] = float(shapiro(series).pvalue)
            except Exception:
                pass
        try:
            item["jarque_bera_p"] = float(jarque_bera(series).pvalue)
        except Exception:
            pass
        if adfuller is not None and len(series) >= 20:
            try:
                item["adf_p"] = float(adfuller(series, autolag="AIC")[1])
            except Exception:
                pass
        if kpss is not None and len(series) >= 20:
            try:
                with warnings.catch_warnings():
                    warnings.simplefilter("ignore")
                    item["kpss_p"] = float(kpss(series, nlags="auto")[1])
            except Exception:
                pass
        res[col] = item
    return res


def trend_analysis(df: pd.DataFrame) -> dict:
    if df.empty:
        return {}
    out = {}
    x = np.arange(len(df)).reshape(-1, 1)
    for col in ["exports", "imports", "balance"]:
        if col not in df.columns:
            continue
        y = pd.to_numeric(df[col], errors="coerce").to_numpy()
        mask = np.isfinite(y)
        if mask.sum() < 3:
            continue
        model = LinearRegression().fit(x[mask], y[mask])
        out[col] = {
            "slope_per_period": float(model.coef_[0]),
            "intercept": float(model.intercept_),
            "r2": float(model.score(x[mask], y[mask])),
            "latest_value": float(y[mask][-1]),
        }
    return out


def detect_anomalies(df: pd.DataFrame) -> pd.DataFrame:
    if df.empty:
        return df
    out = df.copy()
    cols = [c for c in ["exports", "imports", "balance"] if c in out.columns]
    if len(cols) < 2:
        out["anomaly_score"] = np.nan
        out["is_anomaly"] = False
        return out
    features = out[cols].astype(float).ffill().bfill()
    model = IsolationForest(contamination=0.05, random_state=42)
    out["anomaly_score"] = model.fit_predict(features)
    out["is_anomaly"] = out["anomaly_score"] == -1
    return out


def cluster_regimes(df: pd.DataFrame, n_clusters: int = 3) -> pd.DataFrame:
    if df.empty:
        return df
    out = df.copy()
    cols = [c for c in ["exports_yoy", "imports_yoy", "coverage_ratio", "balance"] if c in out.columns]
    if len(cols) < 2:
        out["cluster"] = 0
        return out
    X = out[cols].replace([np.inf, -np.inf], np.nan).interpolate(limit_direction="both").ffill().bfill()
    if len(X) < n_clusters:
        out["cluster"] = 0
        return out
    scaler = StandardScaler()
    Xs = scaler.fit_transform(X)
    kmeans = KMeans(n_clusters=n_clusters, n_init=10, random_state=42)
    out["cluster"] = kmeans.fit_predict(Xs)
    return out


def seasonal_summary(df: pd.DataFrame) -> dict:
    if df.empty or "month" not in df.columns:
        return {}
    out = {}
    for col in ["exports", "imports", "balance"]:
        if col not in df.columns:
            continue
        out[col] = (
            df.groupby("month")[col]
            .agg(["mean", "median", "std", "min", "max"])
            .round(4)
            .to_dict()
        )
    return out


def macro_snapshot(macro_df: pd.DataFrame) -> dict:
    if macro_df.empty:
        return {}
    out = {}
    latest = macro_df.sort_values(["indicator", "date"]).groupby("indicator").tail(1)
    for _, row in latest.iterrows():
        out[row["indicator"]] = {
            "date": str(pd.to_datetime(row["date"]).date()),
            "value": None if pd.isna(row["value"]) else float(row["value"]),
            "unit": row.get("unit"),
            "source": row.get("source"),
        }
    return out


def seasonal_decomposition_pack(df: pd.DataFrame, target: str = "exports"):
    if seasonal_decompose is None or df.empty or target not in df.columns:
        return None
    series = pd.Series(pd.to_numeric(df[target], errors="coerce").values, index=pd.to_datetime(df["date"]))
    series = series.asfreq("MS").interpolate(limit_direction="both")
    if len(series.dropna()) < 24:
        return None
    try:
        return seasonal_decompose(series, model="additive", period=12, extrapolate_trend="freq")
    except Exception:
        return None


def forecast_series(df: pd.DataFrame, target: str = "exports", steps: int = 12) -> dict:
    if df.empty or target not in df.columns:
        return {}
    y = pd.Series(pd.to_numeric(df[target], errors="coerce").values, index=pd.to_datetime(df["date"]))
    y = y.asfreq("MS").interpolate(limit_direction="both").dropna()
    if len(y) < 24:
        return {}
    if SARIMAX is None:
        future_index = pd.date_range(y.index[-1] + pd.offsets.MonthBegin(1), periods=steps, freq="MS")
        forecast = pd.Series([float(y.iloc[-1])] * steps, index=future_index).round(2)
        return {
            "method": "naive_last_value",
            "forecast": {idx.strftime("%Y-%m-%d"): float(val) for idx, val in forecast.items()},
        }
    try:
        model = SARIMAX(y, order=(1, 1, 1), seasonal_order=(1, 1, 1, 12), trend="c", enforce_stationarity=False, enforce_invertibility=False)
        fit = model.fit(disp=False)
        pred = fit.get_forecast(steps=steps).predicted_mean
        conf = fit.get_forecast(steps=steps).conf_int()
        pred = pred.round(2)
        lower = conf.iloc[:, 0].round(2)
        upper = conf.iloc[:, 1].round(2)
        return {
            "method": "sarimax_111_11112",
            "forecast": {idx.strftime("%Y-%m-%d"): float(val) for idx, val in pred.items()},
            "lower": {idx.strftime("%Y-%m-%d"): float(val) for idx, val in lower.items()},
            "upper": {idx.strftime("%Y-%m-%d"): float(val) for idx, val in upper.items()},
        }
    except Exception:
        future_index = pd.date_range(y.index[-1] + pd.offsets.MonthBegin(1), periods=steps, freq="MS")
        forecast = pd.Series([float(y.iloc[-1])] * steps, index=future_index).round(2)
        return {
            "method": "naive_last_value",
            "forecast": {idx.strftime("%Y-%m-%d"): float(val) for idx, val in forecast.items()},
        }


def pca_regimes(df: pd.DataFrame) -> dict:
    cols = [c for c in ["exports_yoy", "imports_yoy", "coverage_ratio", "balance"] if c in df.columns]
    if len(cols) < 2 or len(df) < 5:
        return {}
    X = df[cols].replace([np.inf, -np.inf], np.nan).interpolate(limit_direction="both").ffill().bfill()
    scaler = StandardScaler()
    Xs = scaler.fit_transform(X)
    pca = PCA(n_components=min(2, Xs.shape[1]))
    comps = pca.fit_transform(Xs)
    return {
        "explained_variance_ratio": pca.explained_variance_ratio_.round(4).tolist(),
        "components": pd.DataFrame(comps, columns=[f"PC{i+1}" for i in range(comps.shape[1])]).head(10).to_dict(orient="records"),
    }


def full_analysis_pack(trade_df: pd.DataFrame, macro_df: pd.DataFrame) -> AnalysisPack:
    return AnalysisPack(
        descriptive=descriptive_stats(trade_df),
        correlations=correlations(trade_df),
        stationarity=stationarity_tests(trade_df),
        trend=trend_analysis(trade_df),
        anomaly_summary={
            "count": int(trade_df.get("is_anomaly", pd.Series(dtype=bool)).sum()) if "is_anomaly" in trade_df else 0,
            "clusters": int(trade_df["cluster"].nunique()) if "cluster" in trade_df else 0,
        },
        monthly_seasonality=seasonal_summary(trade_df),
        macro_snapshot=macro_snapshot(macro_df),
        forecast=forecast_series(trade_df, "exports", 12),
    )
