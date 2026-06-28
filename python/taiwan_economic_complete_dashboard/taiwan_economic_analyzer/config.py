"""
Configurações do Taiwan Economic Analyzer
"""
import os
from dataclasses import dataclass, field
from typing import List, Optional

@dataclass
class Config:
    # Paths
    BASE_DIR: str = os.path.dirname(os.path.abspath(__file__))
    DATA_DIR: str = os.path.join(BASE_DIR, "data")
    LOGS_DIR: str = os.path.join(BASE_DIR, "logs")
    ASSETS_DIR: str = os.path.join(BASE_DIR, "assets")

    # Database
    DB_PATH: str = os.path.join(BASE_DIR, "data", "taiwan_economy.db")

    # Dashboard
    DASHBOARD_PNG_PATH: str = os.path.join(ASSETS_DIR, "taiwan_dashboard.png")

    # Web Scraping
    START_YEAR: int = 2015
    END_YEAR: int = 2026
    REQUEST_TIMEOUT: int = 30
    MAX_RETRIES: int = 3
    RETRY_DELAY: float = 2.0
    USER_AGENT: str = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"

    # Data Processing
    OUTLIER_METHOD: str = "iqr"
    MISSING_STRATEGY: str = "interpolate"
    WINSORIZE_LIMIT: float = 0.01

    # Scheduler
    SCHEDULE_INTERVAL_MINUTES: int = 60  # Coleta a cada 60 minutos
    CONTINUOUS_MODE: bool = True

    # Indicators
    INDICATORS: List[str] = field(default_factory=lambda: [
        "exports", "imports", "balance", "gdp_growth", "industrial_production",
        "inflation", "unemployment", "interest_rate", "exchange_rate"
    ])

    # Logging
    LOG_LEVEL: str = "INFO"
    LOG_FORMAT: str = "%(asctime)s | %(levelname)-8s | %(name)s | %(message)s"

    def __post_init__(self):
        os.makedirs(self.DATA_DIR, exist_ok=True)
        os.makedirs(self.LOGS_DIR, exist_ok=True)
        os.makedirs(self.ASSETS_DIR, exist_ok=True)


CONFIG = Config()
