"""
Módulo de Processamento e Limpeza de Dados
Realiza tratamento completo dos dados coletados
"""
import logging
from datetime import datetime
from typing import Dict, Optional, Tuple

import numpy as np
import pandas as pd
from scipy import stats
from sklearn.ensemble import IsolationForest

from config import CONFIG

logger = logging.getLogger("TaiwanProcessor")


class DataProcessor:
    """
    Processador de dados economicos de Taiwan.
    Realiza limpeza, tratamento de missing, outliers e engenharia de features.
    """

    EXPECTED_NUMERIC_COLS = [
        'exports', 'imports', 'balance', 'gdp_growth',
        'inflation', 'unemployment', 'industrial_production',
        'interest_rate', 'exchange_rate',
    ]

    COLUMN_ALIASES = {
        'gdp': 'gdp_growth',
        'gdp_growth_rate': 'gdp_growth',
    }

    def __init__(self, config=CONFIG):
        self.config = config
        self.original_stats = {}
        self.processing_log = []

    def _available_numeric_cols(self, df: pd.DataFrame) -> list:
        """Retorna apenas colunas numericas esperadas presentes no DataFrame."""
        return [c for c in self.EXPECTED_NUMERIC_COLS if c in df.columns]

    def process(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Pipeline completo de processamento de dados.
        """
        logger.info("\n" + "=" * 70)
        logger.info("PROCESSAMENTO DE DADOS")
        logger.info("=" * 70)

        df = df.copy()
        self.original_stats = {
            'rows': len(df),
            'columns': len(df.columns),
            'missing': df.isnull().sum().sum(),
            'duplicates': df.duplicated().sum(),
            'date_range': (df['date'].min(), df['date'].max()) if 'date' in df.columns else None
        }

        # Pipeline de processamento
        df = self._standardize_columns(df)
        df = self._handle_duplicates(df)
        df = self._handle_missing(df)
        df = self._handle_outliers(df)
        df = self._engineer_features(df)
        df = self._validate(df)

        logger.info("OK Processamento concluido!")
        logger.info(f"  Registros: {len(df)}")
        logger.info(f"  Colunas: {len(df.columns)}")

        return df

    def _standardize_columns(self, df: pd.DataFrame) -> pd.DataFrame:
        """Padroniza colunas e tipos de dados"""
        logger.info("[1/6] Padronizando colunas...")

        # Normalizar nomes alternativos de colunas vindos das fontes externas
        rename_map = {
            old: new for old, new in self.COLUMN_ALIASES.items()
            if old in df.columns and new not in df.columns
        }
        if rename_map:
            df = df.rename(columns=rename_map)
            logger.info(f"  Colunas renomeadas: {rename_map}")

        # Garantir datas validas e ordenacao cronologica
        df['date'] = pd.to_datetime(df['date'], errors='coerce')
        before = len(df)
        df = df.dropna(subset=['date'])
        removed = before - len(df)
        if removed:
            logger.info(f"  {removed} registros com data invalida removidos")
        df = df.sort_values('date').reset_index(drop=True)
        df['year'] = df['date'].dt.year
        df['month'] = df['date'].dt.month
        df['quarter'] = df['date'].dt.quarter

        # Garantir colunas numericas
        for col in self._available_numeric_cols(df):
            df[col] = pd.to_numeric(df[col], errors='coerce')

        # Calcular balance se nao existir
        if 'balance' not in df.columns and 'exports' in df.columns and 'imports' in df.columns:
            df['balance'] = df['exports'] - df['imports']
            logger.info("  Balance calculado: exports - imports")

        self.processing_log.append("Padronizacao de colunas concluida")
        return df

    def _handle_duplicates(self, df: pd.DataFrame) -> pd.DataFrame:
        """Remove registros duplicados"""
        logger.info("[2/6] Removendo duplicados...")

        before = len(df)
        df = df.drop_duplicates(subset=['date'], keep='first')
        removed = before - len(df)

        if removed > 0:
            logger.info(f"  {removed} duplicados removidos")
        else:
            logger.info("  Nenhum duplicado encontrado")

        self.processing_log.append(f"Duplicados removidos: {removed}")
        return df

    def _handle_missing(self, df: pd.DataFrame) -> pd.DataFrame:
        """Trata valores faltantes"""
        logger.info("[3/6] Tratando missing values...")

        numeric_cols = self._available_numeric_cols(df)
        if not numeric_cols:
            logger.info("  Nenhuma coluna numerica para tratar")
            return df

        missing_before = df[numeric_cols].isnull().sum().sum()

        if missing_before > 0:
            logger.info(f"  Missing antes: {missing_before} valores")

            for col in numeric_cols:
                if col in df.columns and df[col].isnull().any():
                    missing_count = df[col].isnull().sum()

                    # Interpolacao linear
                    df[col] = df[col].interpolate(method='linear', limit_direction='both')

                    # Se ainda houver NaN (bordas), usar ffill/bfill
                    df[col] = df[col].ffill().bfill()

                    # Se ainda persistir, usar media movel
                    if df[col].isnull().any():
                        df[col] = df[col].fillna(df[col].rolling(window=6, min_periods=1).mean())

                    logger.info(f"    {col}: {missing_count} valores tratados")

            # Recalcular balance
            if {'balance', 'exports', 'imports'}.issubset(df.columns):
                df['balance'] = df['exports'] - df['imports']

            missing_after = df[numeric_cols].isnull().sum().sum()
            logger.info(f"  Missing depois: {missing_after} valores")
        else:
            logger.info("  Nenhum valor faltante")

        self.processing_log.append(f"Missing tratados: {missing_before}")
        return df

    def _handle_outliers(self, df: pd.DataFrame) -> pd.DataFrame:
        """Detecta e trata outliers"""
        logger.info("[4/6] Detectando e tratando outliers...")

        numeric_cols = ['exports', 'imports']
        outlier_counts = {}

        for col in numeric_cols:
            if col not in df.columns:
                continue

            # Metodo IQR
            Q1 = df[col].quantile(0.25)
            Q3 = df[col].quantile(0.75)
            IQR = Q3 - Q1
            lower = Q1 - 1.5 * IQR
            upper = Q3 + 1.5 * IQR

            outliers = df[(df[col] < lower) | (df[col] > upper)]
            outlier_counts[col] = len(outliers)

            # Winsorizacao (cap nos percentis 1% e 99%)
            lower_cap = df[col].quantile(self.config.WINSORIZE_LIMIT)
            upper_cap = df[col].quantile(1 - self.config.WINSORIZE_LIMIT)
            df[col] = df[col].clip(lower=lower_cap, upper=upper_cap)

            logger.info(f"    {col}: {len(outliers)} outliers -> winsorizados")

        # Recalcular balance
        if {'balance', 'exports', 'imports'}.issubset(df.columns):
            df['balance'] = df['exports'] - df['imports']

        # Isolation Forest para deteccao multivariada
        try:
            if {'exports', 'imports', 'balance'}.issubset(df.columns):
                features = df[['exports', 'imports', 'balance']].dropna()
                if len(features) > 20:
                    iso_forest = IsolationForest(contamination=0.05, random_state=42)
                    outlier_labels = iso_forest.fit_predict(features)
                    n_outliers = (outlier_labels == -1).sum()
                    logger.info(f"  Isolation Forest: {n_outliers} outliers multivariados detectados")
        except Exception as e:
            logger.warning(f"  Isolation Forest falhou: {e}")

        self.processing_log.append(f"Outliers tratados: {outlier_counts}")
        return df

    def _engineer_features(self, df: pd.DataFrame) -> pd.DataFrame:
        """Engenharia de features"""
        logger.info("[5/6] Engenharia de features...")

        # YoY (Year-over-Year)
        for col in ['exports', 'imports', 'balance']:
            if col in df.columns:
                df[f'{col}_yoy'] = df[col].pct_change(12) * 100

        # MoM (Month-over-Month)
        for col in ['exports', 'imports', 'balance']:
            if col in df.columns:
                df[f'{col}_mom'] = df[col].pct_change(1) * 100

        # Medias moveis
        for col in ['exports', 'imports']:
            if col in df.columns:
                df[f'{col}_ma3'] = df[col].rolling(3).mean()
                df[f'{col}_ma6'] = df[col].rolling(6).mean()
                df[f'{col}_ma12'] = df[col].rolling(12).mean()

        # Volatilidade (desvio padrao movel)
        for col in ['exports', 'imports', 'balance']:
            if col in df.columns:
                df[f'{col}_vol'] = df[col].rolling(12).std()

        # Razao de cobertura
        if 'exports' in df.columns and 'imports' in df.columns:
            df['coverage_ratio'] = (df['exports'] / df['imports']) * 100

        # Diferenca exports - imports
        if 'exports' in df.columns and 'imports' in df.columns:
            df['trade_gap'] = df['exports'] - df['imports']

        # Indicadores compostos
        if 'gdp_growth' in df.columns and 'inflation' in df.columns:
            df['misery_index'] = df['unemployment'] + df['inflation'] if 'unemployment' in df.columns else df['inflation']

        # Lag features
        for col in ['exports', 'imports']:
            if col in df.columns:
                df[f'{col}_lag1'] = df[col].shift(1)
                df[f'{col}_lag3'] = df[col].shift(3)
                df[f'{col}_lag6'] = df[col].shift(6)

        # Taxa de crescimento acumulada
        for col in ['exports', 'imports']:
            if col in df.columns:
                df[f'{col}_ytd_growth'] = df.groupby('year')[col].transform(
                    lambda x: (x.iloc[-1] / x.iloc[0] - 1) * 100 if len(x) > 1 else 0
                )

        df = df.sort_values('date').reset_index(drop=True)
        logger.info(f"  Features criadas: {len(df.columns) - 10} novas features")
        self.processing_log.append(f"Features engenheiradas: {len(df.columns)}")
        return df

    def _validate(self, df: pd.DataFrame) -> pd.DataFrame:
        """Validacao final dos dados"""
        logger.info("[6/6] Validando dados...")

        df = df.dropna(subset=['date']).sort_values('date').reset_index(drop=True)

        # Verificar ordenacao (NaT quebra is_monotonic_increasing mesmo com datas ordenadas)
        assert df['date'].is_monotonic_increasing, "Datas nao ordenadas!"

        # Verificar valores negativos
        if 'exports' in df.columns:
            assert (df['exports'] >= 0).all(), "Exportacoes negativas!"
        if 'imports' in df.columns:
            assert (df['imports'] >= 0).all(), "Importacoes negativas!"

        # Verificar consistencia do balance
        if 'balance' in df.columns and 'exports' in df.columns and 'imports' in df.columns:
            balance_check = df['exports'] - df['imports']
            assert np.allclose(df['balance'], balance_check, rtol=1e-5), "Balance inconsistente!"

        # Verificar duplicados
        assert df['date'].duplicated().sum() == 0, "Datas duplicadas encontradas!"

        # Verificar missing
        numeric_cols = df.select_dtypes(include=[np.number]).columns
        missing_count = df[numeric_cols].isnull().sum().sum()
        logger.info(f"  Validacao OK - Missing remanescentes: {missing_count}")

        self.processing_log.append("Validacao concluida com sucesso")
        return df

    def get_processing_summary(self) -> Dict:
        """Retorna resumo do processamento"""
        return {
            'original_stats': self.original_stats,
            'processing_log': self.processing_log,
            'timestamp': datetime.now().isoformat()
        }
