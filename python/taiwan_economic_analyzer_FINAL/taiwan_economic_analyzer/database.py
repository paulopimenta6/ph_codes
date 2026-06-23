"""
Modulo de Gerenciamento do Banco de Dados SQLite
"""
import os
import json
import logging
import sqlite3
from datetime import datetime
from typing import Dict, List, Tuple, Optional, Any

import pandas as pd
import numpy as np

from config import CONFIG

logger = logging.getLogger("TaiwanDatabase")


class DatabaseManager:
    """Gerenciador de banco de dados SQLite para Taiwan Economic Analyzer."""

    def __init__(self, db_path: str = CONFIG.DB_PATH):
        self.db_path = db_path
        self.conn = None
        self.cursor = None

    def connect(self):
        os.makedirs(os.path.dirname(self.db_path), exist_ok=True)
        self.conn = sqlite3.connect(self.db_path, check_same_thread=False)
        self.conn.execute("PRAGMA foreign_keys = ON")
        self.conn.execute("PRAGMA journal_mode = WAL")
        self.cursor = self.conn.cursor()
        logger.info(f"Conectado ao banco: {self.db_path}")
        return self

    def create_schema(self):
        logger.info("\n" + "=" * 70)
        logger.info("CRIANDO SCHEMA DO BANCO DE DADOS")
        logger.info("=" * 70)

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS economic_data (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL,
                year INTEGER,
                month INTEGER,
                quarter INTEGER,
                exports REAL,
                imports REAL,
                balance REAL,
                gdp_growth REAL,
                inflation REAL,
                unemployment REAL,
                industrial_production REAL,
                interest_rate REAL,
                exchange_rate REAL,
                exports_yoy REAL,
                imports_yoy REAL,
                balance_yoy REAL,
                exports_mom REAL,
                imports_mom REAL,
                balance_mom REAL,
                exports_ma3 REAL,
                imports_ma3 REAL,
                exports_ma6 REAL,
                imports_ma6 REAL,
                exports_ma12 REAL,
                imports_ma12 REAL,
                exports_vol REAL,
                imports_vol REAL,
                balance_vol REAL,
                coverage_ratio REAL,
                trade_gap REAL,
                misery_index REAL,
                exports_lag1 REAL,
                imports_lag1 REAL,
                cluster INTEGER,
                source TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(date)
            )
        """)

        self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_date ON economic_data(date)")
        self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_year ON economic_data(year)")
        self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_month ON economic_data(month)")
        self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_year_month ON economic_data(year, month)")

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS monthly_stats (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                month INTEGER UNIQUE,
                avg_exports REAL,
                avg_imports REAL,
                avg_balance REAL,
                std_exports REAL,
                std_imports REAL,
                std_balance REAL,
                min_exports REAL,
                max_exports REAL,
                min_imports REAL,
                max_imports REAL,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS trade_partners (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                partner_name TEXT NOT NULL,
                trade_type TEXT NOT NULL,
                year INTEGER,
                value_usd REAL,
                share_percent REAL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS analysis_results (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                analysis_type TEXT NOT NULL,
                analysis_key TEXT,
                analysis_value TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS execution_log (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                execution_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                data_source TEXT,
                records_count INTEGER,
                status TEXT,
                message TEXT,
                duration_seconds REAL
            )
        """)

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS system_config (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                config_key TEXT UNIQUE,
                config_value TEXT,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

        # Nova tabela para dados MOEA
        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS moea_data (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL,
                year INTEGER,
                month INTEGER,
                total_exports REAL,
                total_imports REAL,
                trade_balance REAL,
                electronic_exports REAL,
                machinery_exports REAL,
                chemicals_exports REAL,
                textiles_exports REAL,
                steel_exports REAL,
                plastic_exports REAL,
                mineral_exports REAL,
                info_tech_exports REAL,
                optoelectronic_exports REAL,
                semiconductor_exports REAL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(date)
            )
        """)

        self.cursor.execute("CREATE INDEX IF NOT EXISTS idx_moea_date ON moea_data(date)")

        # Tabela de alertas
        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS alerts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                alert_type TEXT NOT NULL,
                severity TEXT NOT NULL,
                message TEXT NOT NULL,
                metric_name TEXT,
                metric_value REAL,
                threshold_value REAL,
                is_resolved BOOLEAN DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                resolved_at TIMESTAMP
            )
        """)

        self.conn.commit()
        logger.info("Schema criado com sucesso!")

    def insert_economic_data(self, df: pd.DataFrame):
        self.cursor.execute("DELETE FROM economic_data")
        columns = [
            'date', 'year', 'month', 'quarter',
            'exports', 'imports', 'balance', 'gdp_growth', 'inflation',
            'unemployment', 'industrial_production', 'interest_rate', 'exchange_rate',
            'exports_yoy', 'imports_yoy', 'balance_yoy',
            'exports_mom', 'imports_mom', 'balance_mom',
            'exports_ma3', 'imports_ma3', 'exports_ma6', 'imports_ma6',
            'exports_ma12', 'imports_ma12',
            'exports_vol', 'imports_vol', 'balance_vol',
            'coverage_ratio', 'trade_gap', 'misery_index',
            'exports_lag1', 'imports_lag1',
            'cluster', 'source'
        ]
        available_cols = [c for c in columns if c in df.columns]
        df_insert = df[available_cols].copy()
        df_insert['date'] = df_insert['date'].dt.strftime('%Y-%m-%d')
        placeholders = ','.join(['?' for _ in available_cols])
        self.cursor.executemany(
            f"INSERT INTO economic_data ({','.join(available_cols)}) VALUES ({placeholders})",
            df_insert.values.tolist()
        )
        self.conn.commit()
        logger.info(f"{len(df_insert)} registros inseridos em economic_data")

    def insert_moea_data(self, df: pd.DataFrame):
        """Insere dados do MOEA Taiwan"""
        self.cursor.execute("DELETE FROM moea_data")
        columns = [
            'date', 'year', 'month', 'total_exports', 'total_imports', 'trade_balance',
            'electronic_exports', 'machinery_exports', 'chemicals_exports',
            'textiles_exports', 'steel_exports', 'plastic_exports', 'mineral_exports',
            'info_tech_exports', 'optoelectronic_exports', 'semiconductor_exports'
        ]
        available_cols = [c for c in columns if c in df.columns]
        if not available_cols:
            logger.warning("Nenhuma coluna MOEA disponivel para insercao")
            return
        df_insert = df[available_cols].copy()
        df_insert['date'] = pd.to_datetime(df_insert['date']).dt.strftime('%Y-%m-%d')
        placeholders = ','.join(['?' for _ in available_cols])
        self.cursor.executemany(
            f"INSERT INTO moea_data ({','.join(available_cols)}) VALUES ({placeholders})",
            df_insert.values.tolist()
        )
        self.conn.commit()
        logger.info(f"{len(df_insert)} registros MOEA inseridos")

    def insert_monthly_stats(self, df: pd.DataFrame):
        self.cursor.execute("DELETE FROM monthly_stats")
        numeric_cols = ['exports', 'imports', 'balance']
        available_cols = [c for c in numeric_cols if c in df.columns]
        if not available_cols:
            return
        monthly = df.groupby('month')[available_cols].agg(['mean', 'std', 'min', 'max']).round(2)
        for month in range(1, 13):
            if month in monthly.index:
                row = monthly.loc[month]
                values = [
                    month,
                    row.get(('exports', 'mean')), row.get(('imports', 'mean')), row.get(('balance', 'mean')),
                    row.get(('exports', 'std')), row.get(('imports', 'std')), row.get(('balance', 'std')),
                    row.get(('exports', 'min')), row.get(('exports', 'max')),
                    row.get(('imports', 'min')), row.get(('imports', 'max'))
                ]
                self.cursor.execute("""
                    INSERT INTO monthly_stats 
                    (month, avg_exports, avg_imports, avg_balance, std_exports, std_imports, std_balance,
                     min_exports, max_exports, min_imports, max_imports)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, values)
        self.conn.commit()
        logger.info("Estatisticas mensais inseridas")

    def insert_partners(self, partners_data: List[Tuple]):
        self.cursor.execute("DELETE FROM trade_partners")
        self.cursor.executemany("""
            INSERT INTO trade_partners (partner_name, trade_type, year, value_usd, share_percent)
            VALUES (?, ?, ?, ?, ?)
        """, partners_data)
        self.conn.commit()
        logger.info(f"{len(partners_data)} parceiros inseridos")

    def _serialize_for_json(self, obj: Any) -> Any:
        """Converte objetos para formato JSON-serializavel."""
        if isinstance(obj, pd.DataFrame):
            return obj.to_dict(orient='split')
        if isinstance(obj, pd.Series):
            return {str(k): self._serialize_for_json(v) for k, v in obj.items()}
        if isinstance(obj, dict):
            return {str(k): self._serialize_for_json(v) for k, v in obj.items()}
        if isinstance(obj, (list, tuple)):
            return [self._serialize_for_json(item) for item in obj]
        if isinstance(obj, (np.integer, np.floating)):
            return obj.item()
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return obj

    def insert_analysis(self, results: Dict):
        self.cursor.execute("DELETE FROM analysis_results WHERE analysis_type = 'multivariate'")
        for key, value in results.items():
            safe_value = self._serialize_for_json(value)
            self.cursor.execute("""
                INSERT INTO analysis_results (analysis_type, analysis_key, analysis_value)
                VALUES (?, ?, ?)
            """, ('multivariate', key, json.dumps(safe_value, default=str)))
        self.conn.commit()
        logger.info("Resultados de analise inseridos")

    def create_alert(self, alert_type: str, severity: str, message: str,
                     metric_name: str = None, metric_value: float = None,
                     threshold_value: float = None):
        """Cria um alerta no sistema"""
        self.cursor.execute("""
            INSERT INTO alerts (alert_type, severity, message, metric_name, metric_value, threshold_value)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (alert_type, severity, message, metric_name, metric_value, threshold_value))
        self.conn.commit()
        logger.warning(f"ALERTA [{severity}]: {message}")

    def get_active_alerts(self) -> pd.DataFrame:
        """Retorna alertas ativos"""
        query = "SELECT * FROM alerts WHERE is_resolved = 0 ORDER BY created_at DESC"
        return pd.read_sql_query(query, self.conn)

    def resolve_alert(self, alert_id: int):
        """Resolve um alerta"""
        self.cursor.execute("""
            UPDATE alerts SET is_resolved = 1, resolved_at = CURRENT_TIMESTAMP
            WHERE id = ?
        """, (alert_id,))
        self.conn.commit()

    def log_execution(self, source: str, count: int, status: str, 
                     message: str = '', duration: float = 0.0):
        self.cursor.execute("""
            INSERT INTO execution_log (data_source, records_count, status, message, duration_seconds)
            VALUES (?, ?, ?, ?, ?)
        """, (source, count, status, message, duration))
        self.conn.commit()

    def get_summary(self) -> Dict:
        summary = {}
        for table in ['economic_data', 'monthly_stats', 'trade_partners', 
                       'analysis_results', 'execution_log', 'moea_data', 'alerts']:
            self.cursor.execute(f"SELECT COUNT(*) FROM {table}")
            summary[table] = self.cursor.fetchone()[0]
        return summary

    def get_latest_data(self, n: int = 12) -> pd.DataFrame:
        query = f"SELECT * FROM economic_data ORDER BY date DESC LIMIT {n}"
        return pd.read_sql_query(query, self.conn)

    def get_data_range(self, start_date: str, end_date: str) -> pd.DataFrame:
        query = """
            SELECT * FROM economic_data 
            WHERE date BETWEEN ? AND ? 
            ORDER BY date
        """
        return pd.read_sql_query(query, self.conn, params=(start_date, end_date))

    def get_all_data(self) -> pd.DataFrame:
        query = "SELECT * FROM economic_data ORDER BY date"
        df = pd.read_sql_query(query, self.conn)
        df['date'] = pd.to_datetime(df['date'])
        return df

    def get_moea_data(self) -> pd.DataFrame:
        query = "SELECT * FROM moea_data ORDER BY date"
        df = pd.read_sql_query(query, self.conn)
        df['date'] = pd.to_datetime(df['date'])
        return df

    def get_execution_history(self, limit: int = 10) -> pd.DataFrame:
        query = f"""
            SELECT * FROM execution_log 
            ORDER BY execution_date DESC 
            LIMIT {limit}
        """
        return pd.read_sql_query(query, self.conn)

    def set_config(self, key: str, value: str):
        self.cursor.execute("""
            INSERT OR REPLACE INTO system_config (config_key, config_value)
            VALUES (?, ?)
        """, (key, value))
        self.conn.commit()

    def get_config(self, key: str) -> Optional[str]:
        self.cursor.execute("SELECT config_value FROM system_config WHERE config_key = ?", (key,))
        result = self.cursor.fetchone()
        return result[0] if result else None

    def close(self):
        if self.conn:
            self.conn.close()
            logger.info("Conexao com banco fechada")

    def __enter__(self):
        self.connect()
        self.create_schema()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()
