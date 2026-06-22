import tempfile
import unittest
from pathlib import Path

import pandas as pd
import numpy as np

from analysis import cluster_regimes, detect_anomalies, full_analysis_pack, forecast_series
from cleaning import clean_trade_data
from database import init_db, load_trade_data, upsert_trade_data
from dashboard_png import make_dashboard_png
from scraper import TaiwanEconomicScraper, parse_numeric


class TestTaiwanProject(unittest.TestCase):
    def test_parse_numeric(self):
        self.assertEqual(parse_numeric("1,234.5"), 1234.5)
        self.assertEqual(parse_numeric("12.5M"), 12_500_000.0)
        self.assertEqual(parse_numeric("3.2B"), 3_200_000_000.0)
        self.assertIsNone(parse_numeric("n/a"))

    def test_cleaning(self):
        df = pd.DataFrame(
            {
                "date": pd.date_range("2023-01-01", periods=24, freq="MS"),
                "exports": [100 + i for i in range(24)],
                "imports": [80 + i for i in range(24)],
                "balance": [20] * 24,
            }
        )
        df.loc[5, "exports"] = 10000
        clean = clean_trade_data(df)
        self.assertIn("exports_yoy", clean.columns)
        self.assertTrue(clean["exports"].isna().sum() == 0)
        self.assertEqual(len(clean), 24)

    def test_db_roundtrip(self):
        with tempfile.TemporaryDirectory() as tmp:
            db = Path(tmp) / "test.sqlite"
            init_db(db)
            df = pd.DataFrame(
                {
                    "date": pd.date_range("2023-01-01", periods=24, freq="MS"),
                    "exports": [100 + i * 3 for i in range(24)],
                    "imports": [80 + i * 2 for i in range(24)],
                    "balance": [20 + i for i in range(24)],
                }
            )
            clean = clean_trade_data(df)
            clean = detect_anomalies(clean)
            clean = cluster_regimes(clean, n_clusters=2)
            upsert_trade_data(db, clean, source="synthetic")
            loaded = load_trade_data(db)
            self.assertEqual(len(loaded), len(clean))

    def test_scraper_synthetic(self):
        scraper = TaiwanEconomicScraper()
        result = scraper.collect(live=False)
        self.assertFalse(result.trade.empty)
        self.assertFalse(result.macro.empty)
        self.assertIn("source", result.snapshot)

    def test_analysis_pack(self):
        trade = pd.DataFrame(
            {
                "date": pd.date_range("2022-01-01", periods=36, freq="MS"),
                "exports": [100 + i * 2 + (5 if i % 12 == 0 else 0) for i in range(36)],
                "imports": [80 + i * 1.5 for i in range(36)],
                "balance": [20 + i * 0.5 for i in range(36)],
            }
        )
        trade = clean_trade_data(trade)
        trade = detect_anomalies(trade)
        trade = cluster_regimes(trade)
        macro = pd.DataFrame(
            {
                "indicator": ["gdp_growth", "gdp_growth"],
                "date": [pd.Timestamp("2022-01-01"), pd.Timestamp("2023-01-01")],
                "value": [3.1, 2.9],
                "unit": ["percent", "percent"],
                "frequency": ["annual", "annual"],
                "source": ["synthetic", "synthetic"],
            }
        )
        macro["year"] = macro["date"].dt.year
        macro["quarter"] = macro["date"].dt.quarter
        pack = full_analysis_pack(trade, macro)
        self.assertIn("exports", pack.descriptive)
        self.assertIsInstance(pack.forecast, dict)

    def test_dashboard_png(self):
        with tempfile.TemporaryDirectory() as tmp:
            trade = pd.DataFrame(
                {
                    "date": pd.date_range("2022-01-01", periods=36, freq="MS"),
                    "exports": [100 + i * 2 for i in range(36)],
                    "imports": [80 + i * 1.5 for i in range(36)],
                    "balance": [20 + i * 0.5 for i in range(36)],
                }
            )
            trade = clean_trade_data(trade)
            trade = detect_anomalies(trade)
            trade = cluster_regimes(trade)
            macro = pd.DataFrame(
                {
                    "indicator": ["gdp_growth"],
                    "date": [pd.Timestamp("2023-01-01")],
                    "value": [3.0],
                    "unit": ["percent"],
                    "frequency": ["annual"],
                    "source": ["synthetic"],
                    "year": [2023],
                    "quarter": [1],
                }
            )
            out = make_dashboard_png(trade, macro, Path(tmp) / "dash.png")
            self.assertTrue(out.exists())

    def test_forecast(self):
        trade = pd.DataFrame(
            {
                "date": pd.date_range("2021-01-01", periods=36, freq="MS"),
                "exports": np.linspace(100, 200, 36),
                "imports": np.linspace(90, 160, 36),
                "balance": np.linspace(10, 40, 36),
            }
        )
        trade = clean_trade_data(trade)
        self.assertTrue(isinstance(forecast_series(trade), dict))


if __name__ == "__main__":
    unittest.main()
