from __future__ import annotations

import json
import logging
import re
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Dict, Iterable, Optional

import numpy as np
import pandas as pd
import requests
from bs4 import BeautifulSoup

from config import Settings

logger = logging.getLogger(__name__)

TE_SERIES_URLS = {
    "exports": "https://tradingeconomics.com/taiwan/exports",
    "imports": "https://tradingeconomics.com/taiwan/imports",
    "balance": "https://tradingeconomics.com/taiwan/balance-of-trade",
}

WB_SERIES = {
    "gdp_growth": "NY.GDP.MKTP.KD.ZG",
    "inflation_cpi": "FP.CPI.TOTL.ZG",
    "exports_gdp": "NE.EXP.GNFS.ZS",
    "imports_gdp": "NE.IMP.GNFS.ZS",
    "current_account_gdp": "BN.CAB.XOKA.GD.ZS",
    "gdp_usd": "NY.GDP.MKTP.CD",
    "population": "SP.POP.TOTL",
    "labor_force": "SL.TLF.TOTL.IN",
}

MOF_SNAPSHOT_URL = "https://www.mof.gov.tw/eng/singlehtml/259?cntId=57876"


def _normalize_whitespace(text: str) -> str:
    return re.sub(r"\s+", " ", text or "").strip()


def parse_numeric(text: str) -> Optional[float]:
    """Parse values like '1,234.5', '12.5M', '3.2B', '45.7%' or '-'. """
    if text is None:
        return None
    s = _normalize_whitespace(str(text))
    if not s or s.lower() in {"n/a", "na", "null", "-", "—", "none", "not available"}:
        return None
    sign = -1 if "(" in s and ")" in s else 1
    s = s.replace(",", "").replace("(", "").replace(")", "").replace("%", "")
    m = re.match(r"^(-?\d+(?:\.\d+)?)([KMBkmb])?$", s)
    if m:
        number = float(m.group(1))
        suffix = (m.group(2) or "").upper()
        multiplier = {"K": 1e3, "M": 1e6, "B": 1e9}.get(suffix, 1.0)
        return sign * number * multiplier
    m2 = re.search(r"-?\d+(?:\.\d+)?", s)
    if m2:
        return sign * float(m2.group(0))
    return None


def parse_date(text: str) -> Optional[pd.Timestamp]:
    if text is None:
        return None
    s = _normalize_whitespace(str(text))
    if not s:
        return None
    for dayfirst in (False, True):
        try:
            dt = pd.to_datetime(s, errors="raise", dayfirst=dayfirst)
            if pd.notna(dt):
                return pd.Timestamp(dt).to_period("M").to_timestamp()
        except Exception:
            pass
    try:
        dt = pd.to_datetime(f"1 {s}", errors="coerce")
        if pd.notna(dt):
            return pd.Timestamp(dt).to_period("M").to_timestamp()
    except Exception:
        pass
    return None


@dataclass
class ScrapeResult:
    trade: pd.DataFrame
    macro: pd.DataFrame
    snapshot: dict
    raw_sources: Dict[str, int]


class TaiwanEconomicScraper:
    """Collects Taiwan economic time series and metadata from public sources.

    If live scraping fails, the collector produces a synthetic fallback so the
    pipeline keeps running and the dashboard stays usable.
    """

    def __init__(self, settings: Settings | None = None):
        self.settings = settings or Settings()
        self.session = requests.Session()
        self.session.headers.update(
            {
                "User-Agent": (
                    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
                    "(KHTML, like Gecko) Chrome/125.0 Safari/537.36"
                ),
                "Accept-Language": "en-US,en;q=0.9",
            }
        )

    def _get(self, url: str) -> Optional[str]:
        for attempt in range(self.settings.max_retries):
            try:
                resp = self.session.get(url, timeout=self.settings.request_timeout)
                resp.raise_for_status()
                if len(resp.text or "") < 400:
                    raise ValueError(f"Response too short: {len(resp.text)} bytes")
                return resp.text
            except Exception as exc:
                logger.warning(
                    "Failed to fetch %s (%s/%s): %s",
                    url,
                    attempt + 1,
                    self.settings.max_retries,
                    exc,
                )
                time.sleep(self.settings.retry_sleep * (attempt + 1))
        return None

    def _parse_te_html(self, html: str, indicator: str) -> pd.DataFrame:
        soup = BeautifulSoup(html, "html.parser")
        records: list[tuple[pd.Timestamp, float]] = []

        for table in soup.find_all("table"):
            rows = table.find_all("tr")
            for row in rows[1:]:
                cells = row.find_all(["td", "th"])
                if len(cells) >= 2:
                    d = parse_date(cells[0].get_text(" ", strip=True))
                    v = parse_numeric(cells[1].get_text(" ", strip=True))
                    if d is not None and v is not None:
                        records.append((d, v))

        if not records:
            scripts = "\n".join(script.get_text(" ", strip=True) for script in soup.find_all("script"))
            for pat in (
                r'"data"\s*:\s*(\[\[.*?\]\])',
                r"seriesData\s*=\s*(\[\[.*?\]\])",
                r"historicalData\s*=\s*(\[\[.*?\]\])",
            ):
                m = re.search(pat, scripts, flags=re.S)
                if not m:
                    continue
                try:
                    arr = json.loads(m.group(1))
                except Exception:
                    continue
                for row in arr:
                    if isinstance(row, (list, tuple)) and len(row) >= 2:
                        d = pd.to_datetime(row[0], errors="coerce")
                        if pd.isna(d):
                            d = pd.to_datetime(row[0], unit="ms", errors="coerce")
                        v = parse_numeric(str(row[1]))
                        if pd.notna(d) and v is not None:
                            records.append((pd.Timestamp(d).to_period("M").to_timestamp(), v))
                if records:
                    break

        if not records:
            return pd.DataFrame(columns=["date", indicator])

        df = pd.DataFrame(records, columns=["date", indicator]).dropna()
        df = df.groupby("date", as_index=False)[indicator].mean().sort_values("date")
        return df

    def scrape_trading_economics(self) -> pd.DataFrame:
        frames = []
        for indicator, url in TE_SERIES_URLS.items():
            html = self._get(url)
            if not html:
                continue
            df = self._parse_te_html(html, indicator)
            if len(df) >= 6:
                frames.append(df)
        if not frames:
            return pd.DataFrame(columns=["date", "exports", "imports", "balance"])
        out = frames[0]
        for frame in frames[1:]:
            out = out.merge(frame, on="date", how="outer")
        out = out.sort_values("date").reset_index(drop=True)
        if {"exports", "imports"}.issubset(out.columns):
            out["balance"] = out.get("balance", out["exports"] - out["imports"])
        return out

    def scrape_world_bank(self) -> pd.DataFrame:
        rows = []
        for name, code in WB_SERIES.items():
            url = (
                f"https://api.worldbank.org/v2/country/{self.settings.country_code}"
                f"/indicator/{code}?format=json&per_page=20000"
            )
            try:
                payload = self._get(url)
                if not payload:
                    continue
                data = json.loads(payload)
                if not isinstance(data, list) or len(data) < 2 or not isinstance(data[1], list):
                    continue
                for item in data[1]:
                    year = item.get("date")
                    value = item.get("value")
                    if year is None or value is None:
                        continue
                    try:
                        year = int(year)
                    except Exception:
                        continue
                    rows.append(
                        {
                            "date": pd.Timestamp(year=year, month=1, day=1),
                            "indicator": name,
                            "value": float(value),
                            "unit": "percent" if any(k in name for k in ("growth", "inflation", "gdp", "account")) else "persons_or_usd",
                            "frequency": "annual",
                            "source": "world_bank",
                        }
                    )
            except Exception as exc:
                logger.warning("World Bank failed for %s: %s", name, exc)
        return pd.DataFrame(rows)

    def scrape_mof_snapshot(self) -> dict:
        html = self._get(MOF_SNAPSHOT_URL)
        if not html:
            return {}
        soup = BeautifulSoup(html, "html.parser")
        text = _normalize_whitespace(soup.get_text(" ", strip=True))
        # keep a compact snapshot; useful in the dashboard
        patterns = {
            "exports_yoy": r"total exports expanded by ([\d.]+)% year on year",
            "imports_yoy": r"total imports rose by ([\d.]+)% from a year earlier",
            "trade_balance_usd": r"trade balance of this month was favorable, amounting to US\$([\d.]+)\s*billion",
        }
        out = {"source": "mof_summary", "fetched_at": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")}
        for key, pat in patterns.items():
            m = re.search(pat, text, flags=re.I)
            if m:
                out[key] = float(m.group(1))
        # capture the title if present
        title = soup.title.get_text(" ", strip=True) if soup.title else ""
        if title:
            out["title"] = title
        return out

    def _synthetic_trade(self) -> pd.DataFrame:
        rng = np.random.default_rng(42)
        dates = pd.date_range(f"{self.settings.start_year}-01-01", pd.Timestamp.today().to_period("M").to_timestamp(), freq="MS")
        n = len(dates)
        trend = np.linspace(20000, 52000, n)
        season = 2500 * np.sin(2 * np.pi * np.arange(n) / 12) + 900 * np.sin(4 * np.pi * np.arange(n) / 12)
        cyc = 1800 * np.sin(2 * np.pi * np.arange(n) / 60)
        noise = rng.normal(0, 900, n)
        exports = np.maximum(trend + season + cyc + noise, 12000)
        import_ratio = 0.78 + 0.05 * np.sin(2 * np.pi * np.arange(n) / 24) + rng.normal(0, 0.02, n)
        imports = np.maximum(exports * import_ratio, 10000)
        balance = exports - imports
        return pd.DataFrame(
            {
                "date": dates,
                "exports": np.round(exports, 2),
                "imports": np.round(imports, 2),
                "balance": np.round(balance, 2),
            }
        )

    def _synthetic_macro(self) -> pd.DataFrame:
        rng = np.random.default_rng(7)
        years = range(self.settings.start_year, pd.Timestamp.today().year + 1)
        indicators = {
            "gdp_growth": (3.0, 1.8, "percent"),
            "inflation_cpi": (2.0, 1.4, "percent"),
            "exports_gdp": (64.0, 3.5, "percent"),
            "imports_gdp": (55.0, 3.0, "percent"),
            "current_account_gdp": (12.0, 2.5, "percent"),
            "gdp_usd": (700_000_000_000, 80_000_000_000, "usd"),
        }
        rows = []
        for ind, (loc, scale, unit) in indicators.items():
            for year in years:
                shock = 0.0
                if year == 2020:
                    shock = -1.5 if unit == "percent" else -20_000_000_000
                if year >= 2023 and unit == "percent":
                    shock += 0.5
                if unit == "usd":
                    value = max(loc + (year - self.settings.start_year) * scale + rng.normal(0, scale * 0.35), 0)
                else:
                    value = loc + rng.normal(0, scale) + shock
                    if ind == "exports_gdp":
                        value += 0.2 * (year - self.settings.start_year)
                rows.append(
                    {
                        "date": pd.Timestamp(year=year, month=1, day=1),
                        "indicator": ind,
                        "value": float(round(value, 4)),
                        "unit": unit,
                        "frequency": "annual",
                        "source": "synthetic",
                    }
                )
        return pd.DataFrame(rows)

    def collect(self, live: bool = True) -> ScrapeResult:
        trade = pd.DataFrame()
        macro = pd.DataFrame()
        snapshot: dict = {}
        raw_counts: Dict[str, int] = {}

        if live and self.settings.use_tradingeconomics:
            trade = self.scrape_trading_economics()
            raw_counts["trading_economics_rows"] = len(trade)

        if live and self.settings.use_world_bank:
            macro = self.scrape_world_bank()
            raw_counts["world_bank_rows"] = len(macro)

        if live and self.settings.use_mof_latest_snapshot:
            snapshot = self.scrape_mof_snapshot()
            raw_counts["mof_snapshot_fields"] = len(snapshot)

        if trade.empty:
            trade = self._synthetic_trade()
            raw_counts["synthetic_trade_rows"] = len(trade)

        if macro.empty:
            macro = self._synthetic_macro()
            raw_counts["synthetic_macro_rows"] = len(macro)

        if not snapshot:
            snapshot = {
                "source": "synthetic",
                "fetched_at": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S"),
            }

        return ScrapeResult(
            trade=trade.sort_values("date").reset_index(drop=True),
            macro=macro.sort_values(["indicator", "date"]).reset_index(drop=True),
            snapshot=snapshot,
            raw_sources=raw_counts,
        )
