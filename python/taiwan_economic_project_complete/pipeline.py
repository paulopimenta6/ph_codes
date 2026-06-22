from __future__ import annotations

import argparse
import logging
import time

from analysis import cluster_regimes, detect_anomalies, full_analysis_pack, pca_regimes
from cleaning import clean_macro_data, clean_trade_data
from config import Settings
from dashboard_png import make_dashboard_png
from database import (
    init_db,
    load_trade_data,
    log_execution,
    save_analysis_result,
    upsert_macro_data,
    upsert_trade_data,
)
from scraper import TaiwanEconomicScraper

logger = logging.getLogger("taiwan_pipeline")


def setup_logging(settings: Settings) -> None:
    settings.output_dir.mkdir(parents=True, exist_ok=True)
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
        handlers=[
            logging.FileHandler(settings.log_path, encoding="utf-8"),
            logging.StreamHandler(),
        ],
    )


def run_once(settings: Settings, live: bool = True) -> dict:
    init_db(settings.db_path)
    scraper = TaiwanEconomicScraper(settings)
    result = scraper.collect(live=live)

    trade_clean = clean_trade_data(result.trade)
    trade_clean = detect_anomalies(trade_clean)
    trade_clean = cluster_regimes(trade_clean, n_clusters=3)

    macro_clean = clean_macro_data(result.macro)
    analysis = full_analysis_pack(trade_clean, macro_clean)
    pca_info = pca_regimes(trade_clean)

    upsert_trade_data(settings.db_path, trade_clean, source="live" if live else "synthetic")
    upsert_macro_data(settings.db_path, macro_clean, source_default="world_bank")

    save_analysis_result(settings.db_path, "descriptive", analysis.descriptive)
    save_analysis_result(settings.db_path, "correlations", analysis.correlations)
    save_analysis_result(settings.db_path, "stationarity", analysis.stationarity)
    save_analysis_result(settings.db_path, "trend", analysis.trend)
    save_analysis_result(settings.db_path, "macro_snapshot", analysis.macro_snapshot)
    save_analysis_result(settings.db_path, "anomaly_summary", analysis.anomaly_summary)
    save_analysis_result(settings.db_path, "forecast", analysis.forecast)
    save_analysis_result(settings.db_path, "pca_regimes", pca_info)
    save_analysis_result(settings.db_path, "source_snapshot", result.snapshot)

    make_dashboard_png(trade_clean, macro_clean, settings.dashboard_path)
    log_execution(
        settings.db_path,
        "live" if live else "synthetic",
        len(trade_clean) + len(macro_clean),
        "SUCCESS",
        "Pipeline completed successfully",
    )

    return {
        "trade_rows": len(trade_clean),
        "macro_rows": len(macro_clean),
        "analysis": analysis,
        "dashboard_path": str(settings.dashboard_path),
        "db_path": str(settings.db_path),
        "raw_sources": result.raw_sources,
    }


def run_forever(settings: Settings, live: bool = True, interval_minutes: int = 60):
    logger.info("Continuous mode enabled. Interval=%s minutes", interval_minutes)
    while True:
        try:
            report = run_once(settings, live=live)
            logger.info("Pipeline ok: %s", report["raw_sources"])
        except Exception as exc:
            logger.exception("Pipeline failed: %s", exc)
            log_execution(settings.db_path, "pipeline", 0, "ERROR", str(exc))
        time.sleep(max(60, interval_minutes * 60))


def main():
    parser = argparse.ArgumentParser(description="Taiwan Economic Indicators Pipeline")
    parser.add_argument("--continuous", action="store_true", help="Run forever")
    parser.add_argument("--interval-minutes", type=int, default=60)
    parser.add_argument("--no-live", action="store_true", help="Disable live scraping and use synthetic fallback")
    args = parser.parse_args()

    settings = Settings()
    setup_logging(settings)
    settings.data_dir.mkdir(parents=True, exist_ok=True)
    settings.output_dir.mkdir(parents=True, exist_ok=True)

    if args.continuous:
        run_forever(settings, live=not args.no_live, interval_minutes=args.interval_minutes)
    else:
        report = run_once(settings, live=not args.no_live)
        print(report)


if __name__ == "__main__":
    main()
