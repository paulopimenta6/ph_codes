from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path


@dataclass(frozen=True)
class Settings:
    """Central configuration for paths, sources and runtime behavior."""

    base_dir: Path = field(default_factory=lambda: Path(__file__).resolve().parent)
    data_dir: Path = field(default_factory=lambda: Path(__file__).resolve().parent / "data")
    output_dir: Path = field(default_factory=lambda: Path(__file__).resolve().parent / "output")

    db_name: str = "taiwan_economic.sqlite"
    dashboard_name: str = "taiwan_dashboard.png"
    log_name: str = "pipeline.log"

    country_code: str = "TWN"
    start_year: int = 2010
    request_timeout: int = 30
    max_retries: int = 3
    retry_sleep: float = 1.5
    continuous_interval_minutes: int = 60

    # Source toggles
    use_tradingeconomics: bool = True
    use_world_bank: bool = True
    use_mof_latest_snapshot: bool = True

    @property
    def db_path(self) -> Path:
        return self.data_dir / self.db_name

    @property
    def dashboard_path(self) -> Path:
        return self.output_dir / self.dashboard_name

    @property
    def log_path(self) -> Path:
        return self.output_dir / self.log_name

    @property
    def timestamp(self) -> str:
        return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
