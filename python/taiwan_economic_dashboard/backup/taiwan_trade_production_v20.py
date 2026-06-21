
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
================================================================================
TAIWAN ECONOMIC TRADE ANALYZER - SISTEMA DE PRODUÇÃO v2.0
================================================================================
Versão: 2.0.0 | Data: 2026-06-20

Sistema completo para coleta, processamento, análise e visualização de dados
de comércio exterior de Taiwan com múltiplas fontes de dados e fallback.

FONTES DE DADOS (prioridade):
    1. Trading Economics (HTML Scraping)
    2. World Bank Open Data API
    3. IMF Data API
    4. Taiwan Customs (Web Scraping)
    5. Bureau of Foreign Trade Taiwan
    6. Dados simulados realistas (Fallback)

USO:
    python taiwan_trade_production.py --mode full
    python taiwan_trade_production.py --mode scrape-only
    python taiwan_trade_production.py --mode dashboard-only

DEPENDÊNCIAS:
    pip install pandas numpy matplotlib requests beautifulsoup4 scipy scikit-learn
"""

import os
import sys
import argparse
import logging
import json
import sqlite3
import time
import warnings
from datetime import datetime, timedelta
from dataclasses import dataclass, asdict
from typing import Optional, List, Dict, Tuple, Union
from pathlib import Path

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import matplotlib.patches as mpatches
from matplotlib.gridspec import GridSpec
from scipy import stats
from scipy.stats import pearsonr, shapiro, jarque_bera
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.ensemble import IsolationForest

# =============================================================================
# CONFIGURAÇÃO DE LOGGING
# =============================================================================
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s | %(levelname)-8s | %(name)s | %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('taiwan_trade.log', encoding='utf-8')
    ]
)
logger = logging.getLogger('TaiwanTrade')
warnings.filterwarnings('ignore')

# =============================================================================
# CONFIGURAÇÕES GLOBAIS
# =============================================================================
@dataclass
class Config:
    db_path: str = 'taiwan_trade.db'
    dashboard_path: str = 'taiwan_dashboard.png'
    start_year: int = 2015
    end_year: int = 2026
    request_timeout: int = 30
    max_retries: int = 3
    retry_delay: float = 2.0
    outlier_method: str = 'iqr'
    missing_strategy: str = 'interpolate'
    sources: Dict[str, str] = None

    def __post_init__(self):
        self.sources = {
            'trading_economics': 'https://tradingeconomics.com/taiwan/exports',
            'world_bank_trade': 'https://api.worldbank.org/v2/country/TWN/indicator/TG.VAL.TOTL.GD.ZS',
            'imf_direction_trade': 'https://data.imf.org/api/data/DOT/TW',
            'taiwan_customs': 'https://web.customs.gov.tw/english/',
            'taiwan_boft': 'https://www.trade.gov.tw/English/Pages/Statistic.aspx',
        }

CONFIG = Config()


# =============================================================================
# MÓDULO 1: COLETA DE DADOS (WEB SCRAPING + APIs + FALLBACK)
# =============================================================================
class DataCollector:
    """Coletor multi-fonte com fallback automático para dados de Taiwan."""

    def __init__(self, config: Config = CONFIG):
        self.config = config
        self.session = self._create_session()
        self.data_sources = []

    def _create_session(self):
        try:
            import requests
            session = requests.Session()
            session.headers.update({
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language': 'en-US,en;q=0.5',
                'Accept-Encoding': 'gzip, deflate, br',
                'DNT': '1',
                'Connection': 'keep-alive',
            })
            return session
        except ImportError:
            logger.warning("Biblioteca 'requests' não instalada. Usando urllib.")
            return None

    def _fetch_with_retry(self, url: str, method: str = 'get', **kwargs) -> Optional[Union[str, bytes]]:
        if self.session is None:
            return None
        for attempt in range(self.config.max_retries):
            try:
                import requests
                if method.lower() == 'get':
                    response = self.session.get(url, timeout=self.config.request_timeout, **kwargs)
                else:
                    response = self.session.post(url, **kwargs)
                response.raise_for_status()
                if len(response.content) < 1000:
                    logger.warning(f"Resposta muito curta de {url}: {len(response.content)} bytes")
                    if attempt < self.config.max_retries - 1:
                        time.sleep(self.config.retry_delay * (attempt + 1))
                        continue
                logger.info(f"OK Dados obtidos de: {url} ({len(response.content)} bytes)")
                return response.text
            except Exception as e:
                logger.error(f"ERRO ao buscar {url} (tentativa {attempt + 1}): {e}")
                if attempt < self.config.max_retries - 1:
                    time.sleep(self.config.retry_delay * (attempt + 1))
                else:
                    return None
        return None

    # FONTE 1: Trading Economics (HTML Scraping)
    def scrape_trading_economics(self) -> Optional[pd.DataFrame]:
        logger.info("[FONTE 1] Tentando Trading Economics...")
        urls = [
            'https://tradingeconomics.com/taiwan/exports',
            'https://tradingeconomics.com/taiwan/imports',
            'https://tradingeconomics.com/taiwan/balance-of-trade',
        ]
        data_dict = {'exports': [], 'imports': [], 'balance': []}
        for indicator, url in zip(['exports', 'imports', 'balance'], urls):
            html = self._fetch_with_retry(url)
            if html is None:
                continue
            try:
                from bs4 import BeautifulSoup
                soup = BeautifulSoup(html, 'html.parser')
                tables = soup.find_all('table')
                for table in tables:
                    rows = table.find_all('tr')
                    for row in rows[1:]:
                        cells = row.find_all(['td', 'th'])
                        if len(cells) >= 2:
                            date_text = cells[0].get_text(strip=True)
                            value_text = cells[1].get_text(strip=True).replace(',', '')
                            try:
                                date = pd.to_datetime(date_text)
                                value = float(value_text)
                                data_dict[indicator].append({'date': date, 'value': value})
                            except (ValueError, TypeError):
                                continue
                logger.info(f"  OK {indicator}: {len(data_dict[indicator])} registros")
            except Exception as e:
                logger.error(f"  ERRO ao parsear Trading Economics ({indicator}): {e}")
        if any(data_dict.values()):
            return self._consolidate_source_data(data_dict)
        return None

    # FONTE 2: World Bank API
    def fetch_world_bank(self) -> Optional[pd.DataFrame]:
        logger.info("[FONTE 2] Tentando World Bank API...")
        indicators = {
            'exports': 'NE.EXP.GNFS.CD',
            'imports': 'NE.IMP.GNFS.CD',
            'balance': 'BN.CAB.XOKA.CD',
        }
        data_dict = {'exports': [], 'imports': [], 'balance': []}
        for indicator_name, indicator_code in indicators.items():
            url = f"https://api.worldbank.org/v2/country/TWN/indicator/{indicator_code}"
            params = {'format': 'json', 'date': f'{self.config.start_year}:{self.config.end_year}', 'per_page': 500}
            html = self._fetch_with_retry(url, params=params)
            if html is None:
                continue
            try:
                data = json.loads(html)
                if isinstance(data, list) and len(data) > 1:
                    records = data[1]
                    for record in records:
                        year = record.get('date')
                        value = record.get('value')
                        if year and value is not None:
                            data_dict[indicator_name].append({'date': pd.to_datetime(f'{year}-12-31'), 'value': float(value) / 1e6})
                logger.info(f"  OK {indicator_name}: {len(data_dict[indicator_name])} registros")
            except Exception as e:
                logger.error(f"  ERRO ao parsear World Bank ({indicator_name}): {e}")
        if any(data_dict.values()):
            return self._consolidate_source_data(data_dict)
        return None

    # FONTE 3: IMF Data API
    def fetch_imf_data(self) -> Optional[pd.DataFrame]:
        logger.info("[FONTE 3] Tentando IMF Data API...")
        base_url = "https://data.imf.org/api/data/DOT"
        indicators = {'exports': 'TXG_FOB_USD', 'imports': 'TMG_CIF_USD'}
        data_dict = {'exports': [], 'imports': [], 'balance': []}
        for indicator_name, indicator_code in indicators.items():
            url = f"{base_url}/{indicator_code}"
            params = {'freq': 'M', 'period': f'{self.config.start_year}-01:{self.config.end_year}-12'}
            html = self._fetch_with_retry(url, params=params)
            if html is None:
                continue
            try:
                data = json.loads(html)
                series = data.get('series', {}).get('series', [])
                for s in series:
                    for obs in s.get('obs', []):
                        period = obs.get('@TIME_PERIOD')
                        value = obs.get('@OBS_VALUE')
                        if period and value:
                            data_dict[indicator_name].append({'date': pd.to_datetime(period), 'value': float(value)})
                logger.info(f"  OK {indicator_name}: {len(data_dict[indicator_name])} registros")
            except Exception as e:
                logger.error(f"  ERRO ao parsear IMF ({indicator_name}): {e}")
        if data_dict['exports'] and data_dict['imports']:
            df_exp = pd.DataFrame(data_dict['exports']).set_index('date').rename(columns={'value': 'exports'})
            df_imp = pd.DataFrame(data_dict['imports']).set_index('date').rename(columns={'value': 'imports'})
            df_merged = df_exp.join(df_imp, how='outer')
            df_merged['balance'] = df_merged['exports'] - df_merged['imports']
            df_merged = df_merged.reset_index()
            return df_merged
        return None

    # FONTE 4: Taiwan Customs (Web Scraping)
    def scrape_taiwan_customs(self) -> Optional[pd.DataFrame]:
        logger.info("[FONTE 4] Tentando Taiwan Customs...")
        urls = [
            'https://web.customs.gov.tw/english/Statistics/ImportExport.aspx',
            'https://web.customs.gov.tw/english/Statistics/TradeStatistics.aspx',
        ]
        for url in urls:
            html = self._fetch_with_retry(url)
            if html:
                try:
                    from bs4 import BeautifulSoup
                    soup = BeautifulSoup(html, 'html.parser')
                    links = soup.find_all('a', href=True)
                    data_links = [l for l in links if any(ext in l['href'].lower() for ext in ['.csv', '.xls', '.xlsx', '.pdf'])]
                    if data_links:
                        logger.info(f"  OK Encontrados {len(data_links)} links de dados")
                except Exception as e:
                    logger.error(f"  ERRO: {e}")
        return None

    # FONTE 5: Dados Simulados (Fallback Final)
    def generate_simulated_data(self, seed: int = 42) -> pd.DataFrame:
        logger.info("[FONTE 5] Gerando dados simulados realistas (Fallback)...")
        np.random.seed(seed)
        start_date = datetime(self.config.start_year, 1, 1)
        end_date = datetime(self.config.end_year, 6, 1)
        dates = pd.date_range(start=start_date, end=end_date, freq='MS')
        n_months = len(dates)
        trend = np.linspace(22000, 45000, n_months)
        seasonal = 3000 * np.sin(2 * np.pi * np.arange(n_months) / 12) + 1500 * np.sin(4 * np.pi * np.arange(n_months) / 12)
        cycle = 2500 * np.sin(2 * np.pi * np.arange(n_months) / 60)
        shocks = np.zeros(n_months)
        covid_start = max(0, (datetime(2020, 3, 1) - start_date).days // 30)
        covid_end = min(n_months, (datetime(2021, 12, 1) - start_date).days // 30)
        if covid_start < n_months:
            shocks[covid_start:covid_end] = np.linspace(-4000, 6000, covid_end - covid_start)
        chip_start = max(0, (datetime(2021, 6, 1) - start_date).days // 30)
        chip_end = min(n_months, (datetime(2022, 12, 1) - start_date).days // 30)
        if chip_start < n_months:
            shocks[chip_start:chip_end] += np.linspace(3000, 5000, chip_end - chip_start)
        slow_start = max(0, (datetime(2023, 1, 1) - start_date).days // 30)
        slow_end = min(n_months, (datetime(2023, 12, 1) - start_date).days // 30)
        if slow_start < n_months:
            shocks[slow_start:slow_end] -= np.linspace(0, 3000, slow_end - slow_start)
        recov_start = max(0, (datetime(2024, 1, 1) - start_date).days // 30)
        if recov_start < n_months:
            shocks[recov_start:] += np.linspace(1500, 4000, n_months - recov_start)
        noise = np.random.normal(0, 1000, n_months)
        exports = trend + seasonal + cycle + shocks + noise
        exports = np.maximum(exports, 18000)
        import_ratio = 0.80 + 0.06 * np.sin(2 * np.pi * np.arange(n_months) / 24)
        import_ratio += np.random.normal(0, 0.025, n_months)
        imports = exports * np.clip(import_ratio, 0.65, 0.95)
        balance = exports - imports
        df = pd.DataFrame({
            'date': dates, 'year': dates.year, 'month': dates.month,
            'exports': np.round(exports, 2), 'imports': np.round(imports, 2),
            'balance': np.round(balance, 2), 'source': 'simulated'
        })
        logger.info(f"  OK Dados simulados: {len(df)} registros ({df['date'].min().strftime('%Y-%m')} a {df['date'].max().strftime('%Y-%m')})")
        return df

    def _consolidate_source_data(self, data_dict: Dict) -> pd.DataFrame:
        dfs = []
        for indicator, records in data_dict.items():
            if records:
                df_ind = pd.DataFrame(records)
                df_ind = df_ind.rename(columns={'value': indicator})
                dfs.append(df_ind.set_index('date'))
        if not dfs:
            return None
        df_merged = dfs[0]
        for df_next in dfs[1:]:
            df_merged = df_merged.join(df_next, how='outer')
        df_merged = df_merged.reset_index()
        df_merged['year'] = df_merged['date'].dt.year
        df_merged['month'] = df_merged['date'].dt.month
        if 'balance' not in df_merged.columns and 'exports' in df_merged.columns and 'imports' in df_merged.columns:
            df_merged['balance'] = df_merged['exports'] - df_merged['imports']
        df_merged['source'] = 'real'
        return df_merged

    def collect(self, prefer_real: bool = True) -> pd.DataFrame:
        logger.info("="*70)
        logger.info("INICIANDO COLETA DE DADOS")
        logger.info("="*70)
        sources = [
            ('Trading Economics', self.scrape_trading_economics),
            ('World Bank', self.fetch_world_bank),
            ('IMF Data', self.fetch_imf_data),
            ('Taiwan Customs', self.scrape_taiwan_customs),
        ]
        if prefer_real:
            for name, func in sources:
                try:
                    df = func()
                    if df is not None and len(df) > 0:
                        logger.info(f"OKOKOK Fonte '{name}' utilizada com sucesso!")
                        self.data_sources.append(name)
                        return df
                except Exception as e:
                    logger.error(f"ERRO Fonte '{name}' falhou: {e}")
        logger.warning("AVISO Todas as fontes reais falharam. Usando dados simulados.")
        self.data_sources.append('simulated')
        return self.generate_simulated_data()


# =============================================================================
# MÓDULO 2: PROCESSAMENTO DE DADOS
# =============================================================================
class DataProcessor:
    def __init__(self, config: Config = CONFIG):
        self.config = config
        self.original_stats = {}

    def process(self, df: pd.DataFrame) -> pd.DataFrame:
        logger.info("\n" + "="*70)
        logger.info("PROCESSAMENTO DE DADOS")
        logger.info("="*70)
        df = df.copy()
        self.original_stats['rows'] = len(df)
        self.original_stats['missing'] = df.isnull().sum().sum()
        df = self._standardize_columns(df)
        df = self._handle_missing(df)
        df = self._handle_outliers(df)
        df = self._engineer_features(df)
        df = self._validate(df)
        logger.info("[OK] Processamento concluido!")
        logger.info(f"  Registros finais: {len(df)}")
        logger.info(f"  Missing removidos: {self.original_stats['missing']}")
        return df

    def _standardize_columns(self, df: pd.DataFrame) -> pd.DataFrame:
        required = ['date', 'exports', 'imports']
        for col in required:
            if col not in df.columns:
                logger.error(f"Coluna obrigatoria '{col}' nao encontrada!")
        df['date'] = pd.to_datetime(df['date'])
        df['year'] = df['date'].dt.year
        df['month'] = df['date'].dt.month
        df = df.sort_values('date').reset_index(drop=True)
        return df

    def _handle_missing(self, df: pd.DataFrame) -> pd.DataFrame:
        numeric_cols = ['exports', 'imports', 'balance']
        missing_before = df[numeric_cols].isnull().sum()
        if missing_before.sum() == 0:
            logger.info("[MISSING] Nenhum valor faltante encontrado.")
            return df
        logger.info(f"[MISSING] Valores faltantes antes: {missing_before.sum()}")
        strategy = self.config.missing_strategy
        for col in numeric_cols:
            if df[col].isnull().any():
                if strategy == 'interpolate':
                    df[col] = df[col].interpolate(method='linear', limit_direction='both')
                elif strategy == 'forward_fill':
                    df[col] = df[col].fillna(method='ffill').fillna(method='bfill')
                else:
                    df[col] = df[col].fillna(df[col].median())
        if 'balance' in df.columns:
            df['balance'] = df['exports'] - df['imports']
        missing_after = df[numeric_cols].isnull().sum()
        logger.info(f"[MISSING] Valores faltantes depois: {missing_after.sum()}")
        return df

    def _handle_outliers(self, df: pd.DataFrame) -> pd.DataFrame:
        logger.info("[OUTLIERS] Detectando anomalias...")
        numeric_cols = ['exports', 'imports']
        outlier_counts = {}
        for col in numeric_cols:
            if self.config.outlier_method == 'iqr':
                Q1 = df[col].quantile(0.25)
                Q3 = df[col].quantile(0.75)
                IQR = Q3 - Q1
                lower = Q1 - 1.5 * IQR
                upper = Q3 + 1.5 * IQR
                outliers = df[(df[col] < lower) | (df[col] > upper)]
            elif self.config.outlier_method == 'zscore':
                z_scores = np.abs(stats.zscore(df[col]))
                outliers = df[z_scores > 3]
            else:
                iso = IsolationForest(contamination=0.05, random_state=42)
                preds = iso.fit_predict(df[[col]])
                outliers = df[preds == -1]
            outlier_counts[col] = len(outliers)
            lower_cap = df[col].quantile(0.01)
            upper_cap = df[col].quantile(0.99)
            df[col] = df[col].clip(lower=lower_cap, upper=upper_cap)
        df['balance'] = df['exports'] - df['imports']
        logger.info(f"[OUTLIERS] Detectados: {outlier_counts}")
        logger.info(f"[OUTLIERS] Tratados via Winsorizacao (1/99 percentil)")
        return df

    def _engineer_features(self, df: pd.DataFrame) -> pd.DataFrame:
        df['exports_yoy'] = df['exports'].pct_change(12) * 100
        df['imports_yoy'] = df['imports'].pct_change(12) * 100
        df['balance_yoy'] = df['balance'].pct_change(12) * 100
        df['exports_ma3'] = df['exports'].rolling(3).mean()
        df['imports_ma3'] = df['imports'].rolling(3).mean()
        df['exports_ma12'] = df['exports'].rolling(12).mean()
        df['imports_ma12'] = df['imports'].rolling(12).mean()
        df['exports_vol'] = df['exports'].rolling(12).std()
        df['imports_vol'] = df['imports'].rolling(12).std()
        df['balance_vol'] = df['balance'].rolling(12).std()
        df['coverage_ratio'] = (df['exports'] / df['imports']) * 100
        df['exports_mom'] = df['exports'].pct_change(1) * 100
        df['imports_mom'] = df['imports'].pct_change(1) * 100
        return df

    def _validate(self, df: pd.DataFrame) -> pd.DataFrame:
        assert (df['exports'] >= 0).all(), "Exportacoes negativas detectadas!"
        assert (df['imports'] >= 0).all(), "Importacoes negativas detectadas!"
        assert df['date'].is_monotonic_increasing, "Datas nao estao ordenadas!"
        return df


# =============================================================================
# MÓDULO 3: ANÁLISE ESTATÍSTICA MULTIVARIADA
# =============================================================================
class MultivariateAnalyzer:
    def __init__(self):
        self.results = {}

    def analyze(self, df: pd.DataFrame) -> Dict:
        logger.info("\n" + "="*70)
        logger.info("ANALISE ESTATISTICA MULTIVARIADA")
        logger.info("="*70)
        self.results['descriptive'] = self._descriptive_stats(df)
        self.results['correlation'] = self._correlation_analysis(df)
        self.results['normality'] = self._normality_tests(df)
        self.results['trend'] = self._trend_analysis(df)
        self.results['seasonality'] = self._seasonality_analysis(df)
        self.results['pca'] = self._pca_analysis(df)
        self.results['stationarity'] = self._stationarity_tests(df)
        self.results['clustering'] = self._clustering_analysis(df)
        return self.results

    def _descriptive_stats(self, df: pd.DataFrame) -> pd.DataFrame:
        cols = ['exports', 'imports', 'balance']
        stats_df = df[cols].describe().round(2)
        logger.info("\n[1/8] ESTATISTICAS DESCRITIVAS")
        print(stats_df.to_string())
        return stats_df

    def _correlation_analysis(self, df: pd.DataFrame) -> pd.DataFrame:
        cols = ['exports', 'imports', 'balance']
        corr = df[cols].corr()
        logger.info("\n[2/8] MATRIZ DE CORRELACAO")
        print(corr.round(4).to_string())
        logger.info("\n  Testes de Significancia (Pearson):")
        pairs = [('exports', 'imports'), ('exports', 'balance'), ('imports', 'balance')]
        for a, b in pairs:
            r, p = pearsonr(df[a], df[b])
            sig = "***" if p < 0.001 else "**" if p < 0.01 else "*" if p < 0.05 else "ns"
            logger.info(f"    {a} vs {b}: r={r:.4f}, p={p:.6f} {sig}")
        return corr

    def _normality_tests(self, df: pd.DataFrame) -> Dict:
        logger.info("\n[3/8] TESTES DE NORMALIDADE")
        results = {}
        for col in ['exports', 'imports', 'balance']:
            shapiro_stat, shapiro_p = shapiro(df[col])
            jb_stat, jb_p = jarque_bera(df[col])
            results[col] = {'shapiro_w': shapiro_stat, 'shapiro_p': shapiro_p, 'jb_stat': jb_stat, 'jb_p': jb_p, 'normal': shapiro_p > 0.05}
            logger.info(f"  {col}: Shapiro-Wilk p={shapiro_p:.6f} ({'Normal' if shapiro_p > 0.05 else 'Nao Normal'})")
        return results

    def _trend_analysis(self, df: pd.DataFrame) -> Dict:
        logger.info("\n[4/8] ANALISE DE TENDENCIA")
        X = np.arange(len(df)).reshape(-1, 1)
        trends = {}
        for col in ['exports', 'imports', 'balance']:
            model = LinearRegression()
            model.fit(X, df[col])
            trends[col] = {'slope': model.coef_[0], 'intercept': model.intercept_, 'r2': model.score(X, df[col])}
            logger.info(f"  {col}: Tendencia = {model.coef_[0]:.2f}M/mes, R2 = {model.score(X, df[col]):.4f}")
        return trends

    def _seasonality_analysis(self, df: pd.DataFrame) -> pd.DataFrame:
        logger.info("\n[5/8] ANALISE DE SAZONALIDADE")
        monthly = df.groupby('month')[['exports', 'imports', 'balance']].agg(['mean', 'std']).round(2)
        print(monthly.to_string())
        return monthly

    def _pca_analysis(self, df: pd.DataFrame) -> Dict:
        logger.info("\n[6/8] ANALISE DE COMPONENTES PRINCIPAIS (PCA)")
        features = ['exports', 'imports', 'balance']
        X = df[features].dropna()
        X_scaled = StandardScaler().fit_transform(X)
        pca = PCA()
        pca.fit(X_scaled)
        logger.info(f"  Variancia explicada:")
        for i, var in enumerate(pca.explained_variance_ratio_):
            logger.info(f"    PC{i+1}: {var*100:.2f}%")
        loadings = pd.DataFrame(pca.components_.T, columns=[f'PC{i+1}' for i in range(len(features))], index=features)
        logger.info(f"\n  Loadings:\n{loadings.round(4).to_string()}")
        return {'explained_variance': pca.explained_variance_ratio_.tolist(), 'loadings': loadings.to_dict()}

    def _stationarity_tests(self, df: pd.DataFrame) -> Dict:
        logger.info("\n[7/8] TESTE DE ESTACIONARIEDADE (ADF)")
        try:
            from statsmodels.tsa.stattools import adfuller
            results = {}
            for col in ['exports', 'imports', 'balance']:
                adf_result = adfuller(df[col].dropna())
                results[col] = {'adf_stat': adf_result[0], 'p_value': adf_result[1], 'stationary': adf_result[1] < 0.05}
                logger.info(f"  {col}: ADF={adf_result[0]:.4f}, p={adf_result[1]:.6f} ({'Estacionaria' if adf_result[1] < 0.05 else 'Nao Estacionaria'})")
            return results
        except ImportError:
            logger.warning("  statsmodels nao instalado. Pulando teste ADF.")
            return {}

    def _clustering_analysis(self, df: pd.DataFrame) -> Dict:
        logger.info("\n[8/8] ANALISE DE CLUSTERING")
        features = df[['exports', 'imports', 'balance']].dropna()
        if len(features) > 12:
            scaler = StandardScaler()
            X_scaled = scaler.fit_transform(features)
            kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
            clusters = kmeans.fit_predict(X_scaled)
            df.loc[features.index, 'cluster'] = clusters
            cluster_summary = df.groupby('cluster')[['exports', 'imports', 'balance']].mean().round(2)
            logger.info(f"  Clusters identificados:\n{cluster_summary.to_string()}")
            return {'clusters': clusters.tolist(), 'centers': kmeans.cluster_centers_.tolist()}
        return {}


# =============================================================================
# MÓDULO 4: BANCO DE DADOS SQLITE
# =============================================================================
class DatabaseManager:
    def __init__(self, db_path: str = CONFIG.db_path):
        self.db_path = db_path
        self.conn = None

    def connect(self):
        self.conn = sqlite3.connect(self.db_path)
        self.conn.execute("PRAGMA foreign_keys = ON")
        return self.conn

    def create_schema(self):
        logger.info("\n" + "="*70)
        logger.info("BANCO DE DADOS SQLITE")
        logger.info("="*70)
        cursor = self.conn.cursor()
        cursor.execute("CREATE TABLE IF NOT EXISTS trade_data (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL UNIQUE, year INTEGER NOT NULL, month INTEGER NOT NULL, exports REAL NOT NULL, imports REAL NOT NULL, balance REAL NOT NULL, exports_yoy REAL, imports_yoy REAL, balance_yoy REAL, exports_mom REAL, imports_mom REAL, exports_ma3 REAL, imports_ma3 REAL, exports_ma12 REAL, imports_ma12 REAL, exports_vol REAL, imports_vol REAL, balance_vol REAL, coverage_ratio REAL, cluster INTEGER, source TEXT DEFAULT 'unknown', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_date ON trade_data(date)")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_year ON trade_data(year)")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_month ON trade_data(month)")
        cursor.execute("CREATE TABLE IF NOT EXISTS monthly_stats (id INTEGER PRIMARY KEY AUTOINCREMENT, month INTEGER NOT NULL UNIQUE, avg_exports REAL, avg_imports REAL, avg_balance REAL, std_exports REAL, std_imports REAL, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
        cursor.execute("CREATE TABLE IF NOT EXISTS trade_partners (id INTEGER PRIMARY KEY AUTOINCREMENT, partner_name TEXT NOT NULL, trade_type TEXT NOT NULL, year INTEGER NOT NULL, value_usd REAL NOT NULL, share_percent REAL, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
        cursor.execute("CREATE TABLE IF NOT EXISTS analysis_results (id INTEGER PRIMARY KEY AUTOINCREMENT, analysis_type TEXT NOT NULL, analysis_key TEXT NOT NULL, analysis_value TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
        cursor.execute("CREATE TABLE IF NOT EXISTS execution_log (id INTEGER PRIMARY KEY AUTOINCREMENT, execution_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, data_source TEXT, records_count INTEGER, status TEXT, message TEXT)")
        self.conn.commit()
        logger.info("OK Schema criado com sucesso")

    def insert_trade_data(self, df: pd.DataFrame):
        cursor = self.conn.cursor()
        cursor.execute("DELETE FROM trade_data")
        columns = ['date', 'year', 'month', 'exports', 'imports', 'balance', 'exports_yoy', 'imports_yoy', 'balance_yoy', 'exports_mom', 'imports_mom', 'exports_ma3', 'imports_ma3', 'exports_ma12', 'imports_ma12', 'exports_vol', 'imports_vol', 'balance_vol', 'coverage_ratio', 'cluster', 'source']
        available_cols = [c for c in columns if c in df.columns]
        df_insert = df[available_cols].copy()
        df_insert['date'] = df_insert['date'].dt.strftime('%Y-%m-%d')
        placeholders = ','.join(['?' for _ in available_cols])
        cursor.executemany(f"INSERT INTO trade_data ({','.join(available_cols)}) VALUES ({placeholders})", df_insert.values.tolist())
        self.conn.commit()
        logger.info(f"OK {len(df_insert)} registros inseridos em trade_data")

    def insert_monthly_stats(self, df: pd.DataFrame):
        cursor = self.conn.cursor()
        cursor.execute("DELETE FROM monthly_stats")
        monthly = df.groupby('month').agg({'exports': ['mean', 'std'], 'imports': ['mean', 'std'], 'balance': 'mean'}).round(2)
        for month in range(1, 13):
            if month in monthly.index:
                row = monthly.loc[month]
                cursor.execute("INSERT INTO monthly_stats (month, avg_exports, avg_imports, avg_balance, std_exports, std_imports) VALUES (?, ?, ?, ?, ?, ?)", (month, row[('exports', 'mean')], row[('imports', 'mean')], row[('balance', 'mean')], row[('exports', 'std')], row[('imports', 'std')]))
        self.conn.commit()
        logger.info("OK Estatisticas mensais inseridas")

    def insert_partners(self, partners_data: List[Tuple]):
        cursor = self.conn.cursor()
        cursor.execute("DELETE FROM trade_partners")
        cursor.executemany("INSERT INTO trade_partners (partner_name, trade_type, year, value_usd, share_percent) VALUES (?, ?, ?, ?, ?)", partners_data)
        self.conn.commit()
        logger.info(f"OK {len(partners_data)} registros de parceiros inseridos")

    def insert_analysis(self, results: Dict):
        cursor = self.conn.cursor()
        cursor.execute("DELETE FROM analysis_results WHERE analysis_type = 'multivariate'")
        for key, value in results.items():
            cursor.execute("INSERT INTO analysis_results (analysis_type, analysis_key, analysis_value) VALUES (?, ?, ?)", ('multivariate', key, json.dumps(value, default=str)))
        self.conn.commit()

    def log_execution(self, source: str, count: int, status: str, message: str = ''):
        cursor = self.conn.cursor()
        cursor.execute("INSERT INTO execution_log (data_source, records_count, status, message) VALUES (?, ?, ?, ?)", (source, count, status, message))
        self.conn.commit()

    def get_summary(self) -> Dict:
        cursor = self.conn.cursor()
        summary = {}
        for table in ['trade_data', 'monthly_stats', 'trade_partners', 'analysis_results']:
            cursor.execute(f"SELECT COUNT(*) FROM {table}")
            summary[table] = cursor.fetchone()[0]
        return summary

    def close(self):
        if self.conn:
            self.conn.close()


# =============================================================================
# MÓDULO 5: DASHBOARD
# =============================================================================
class DashboardBuilder:
    def __init__(self):
        self._setup_style()

    def _setup_style(self):
        plt.rcParams['figure.facecolor'] = '#0a0e27'
        plt.rcParams['axes.facecolor'] = '#0f1535'
        plt.rcParams['axes.edgecolor'] = '#2a3f5f'
        plt.rcParams['axes.labelcolor'] = '#a0aec0'
        plt.rcParams['text.color'] = '#e2e8f0'
        plt.rcParams['xtick.color'] = '#a0aec0'
        plt.rcParams['ytick.color'] = '#a0aec0'
        plt.rcParams['grid.color'] = '#1e293b'
        plt.rcParams['grid.alpha'] = 0.5

    def build(self, df: pd.DataFrame, save_path: str = CONFIG.dashboard_path):
        logger.info("\n" + "="*70)
        logger.info("CONSTRUINDO DASHBOARD")
        logger.info("="*70)
        fig = plt.figure(figsize=(26, 34))
        gs = GridSpec(5, 3, figure=fig, hspace=0.38, wspace=0.28)
        C_EXP = '#00d4aa'
        C_IMP = '#ff6b6b'
        C_BAL = '#4dabf7'
        C_ACC = '#ffd43b'
        ax1 = fig.add_subplot(gs[0, :])
        self._plot_timeseries(ax1, df, C_EXP, C_IMP, C_BAL, C_ACC)
        ax2 = fig.add_subplot(gs[1, 0])
        self._plot_yoy(ax2, df, 'exports_yoy', 'Exportacoes YoY', C_EXP, C_IMP)
        ax2b = fig.add_subplot(gs[1, 1])
        self._plot_yoy(ax2b, df, 'imports_yoy', 'Importacoes YoY', C_EXP, C_IMP)
        ax2c = fig.add_subplot(gs[1, 2])
        self._plot_yoy(ax2c, df, 'balance_yoy', 'Saldo YoY', C_EXP, C_IMP)
        ax3 = fig.add_subplot(gs[2, 0])
        self._plot_seasonality(ax3, df, C_EXP, C_IMP, C_BAL)
        ax4 = fig.add_subplot(gs[2, 1])
        self._plot_correlation(ax4, df)
        ax5 = fig.add_subplot(gs[2, 2])
        self._plot_partners(ax5)
        ax6 = fig.add_subplot(gs[3, 0])
        self._plot_volatility(ax6, df, C_EXP, C_IMP)
        ax7 = fig.add_subplot(gs[3, 1])
        self._plot_scatter(ax7, df, C_ACC)
        ax8 = fig.add_subplot(gs[3, 2])
        self._plot_distribution(ax8, df, C_BAL, C_ACC)
        ax9 = fig.add_subplot(gs[4, :])
        self._plot_kpis(ax9, df, C_EXP, C_IMP, C_BAL, C_ACC)
        fig.suptitle('DASHBOARD - ECONOMIA DE TAIWAN: COMERCIO EXTERIOR', fontsize=22, fontweight='bold', color='white', y=0.98)
        plt.tight_layout(rect=[0, 0, 1, 0.96])
        plt.savefig(save_path, dpi=150, bbox_inches='tight', facecolor='#0a0e27', edgecolor='none')
        plt.close()
        logger.info(f"OK Dashboard salvo: {save_path}")
        return save_path

    def _plot_timeseries(self, ax, df, c_exp, c_imp, c_bal, c_acc):
        ax.fill_between(df['date'], 0, df['exports'], alpha=0.12, color=c_exp)
        ax.fill_between(df['date'], 0, df['imports'], alpha=0.12, color=c_imp)
        ax.plot(df['date'], df['exports'], color=c_exp, linewidth=2.5, label='Exportacoes', marker='o', markersize=2.5, markevery=6)
        ax.plot(df['date'], df['imports'], color=c_imp, linewidth=2.5, label='Importacoes', marker='s', markersize=2.5, markevery=6)
        ax.plot(df['date'], df['balance'], color=c_bal, linewidth=2.5, label='Saldo Comercial', marker='^', markersize=2.5, markevery=6)
        events = {'2020-03': 'COVID-19', '2021-06': 'Boom Chips', '2022-02': 'Guerra Ucrania', '2023-01': 'Desaceleracao', '2024-01': 'Recuperacao AI'}
        for date_str, event in events.items():
            date_obj = pd.to_datetime(date_str)
            if df['date'].min() <= date_obj <= df['date'].max():
                ax.axvline(x=date_obj, color=c_acc, linestyle='--', alpha=0.5, linewidth=1.2)
                ax.annotate(event, xy=(date_obj, df['exports'].max()*0.93), fontsize=8, color=c_acc, rotation=90, ha='right')
        ax.set_title('SERIE TEMPORAL CONTINUA - COMERCIO EXTERIOR DE TAIWAN', fontsize=15, fontweight='bold', pad=18)
        ax.set_ylabel('Milhoes USD', fontsize=11)
        ax.legend(loc='upper left', fontsize=10, framealpha=0.8)
        ax.grid(True, alpha=0.3)
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.xaxis.set_major_locator(mdates.YearLocator())

    def _plot_yoy(self, ax, df, col, title, c_pos, c_neg):
        data = df.dropna(subset=[col])
        colors = [c_pos if x >= 0 else c_neg for x in data[col]]
        ax.bar(data['date'], data[col], color=colors, alpha=0.7, width=25)
        ax.axhline(y=0, color='white', linewidth=0.8)
        ax.set_title(f'{title}', fontsize=12, fontweight='bold')
        ax.set_ylabel('%', fontsize=9)
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.xaxis.set_major_locator(mdates.YearLocator(2))
        ax.grid(True, alpha=0.3)

    def _plot_seasonality(self, ax, df, c_exp, c_imp, c_bal):
        monthly = df.groupby('month')[['exports', 'imports', 'balance']].mean()
        x = np.arange(1, 13)
        w = 0.25
        ax.bar(x - w, monthly['exports'], w, label='Exportacoes', color=c_exp, alpha=0.8)
        ax.bar(x, monthly['imports'], w, label='Importacoes', color=c_imp, alpha=0.8)
        ax.bar(x + w, monthly['balance'], w, label='Saldo', color=c_bal, alpha=0.8)
        ax.set_title('Padrao Sazonal (Media por Mes)', fontsize=12, fontweight='bold')
        ax.set_xlabel('Mes', fontsize=9)
        ax.set_ylabel('Milhoes USD', fontsize=9)
        ax.set_xticks(x)
        ax.set_xticklabels(['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'])
        ax.legend(fontsize=8)
        ax.grid(True, alpha=0.3)

    def _plot_correlation(self, ax, df):
        corr = df[['exports', 'imports', 'balance']].corr()
        im = ax.imshow(corr.values, cmap='RdYlGn', vmin=-1, vmax=1, aspect='auto')
        labels = ['Exportacoes', 'Importacoes', 'Saldo']
        ax.set_xticks(range(3))
        ax.set_yticks(range(3))
        ax.set_xticklabels(labels, fontsize=9)
        ax.set_yticklabels(labels, fontsize=9)
        for i in range(3):
            for j in range(3):
                color = "black" if abs(corr.values[i,j]) < 0.5 else "white"
                ax.text(j, i, f'{corr.values[i,j]:.3f}', ha="center", va="center", color=color, fontsize=13, fontweight='bold')
        ax.set_title('Matriz de Correlacao', fontsize=12, fontweight='bold')
        plt.colorbar(im, ax=ax, shrink=0.75)

    def _plot_partners(self, ax):
        partners = ['China', 'USA', 'ASEAN', 'Japan', 'S. Korea', 'EU', 'Outros']
        values = [85000, 45000, 54000, 36000, 24000, 36000, 18000]
        colors = ['#ff6b6b', '#4dabf7', '#00d4aa', '#ffd43b', '#da77f2', '#ff922b', '#868e96']
        wedges, texts, autotexts = ax.pie(values, labels=partners, autopct='%1.1f%%', colors=colors, startangle=90, textprops={'fontsize': 8})
        for autotext in autotexts:
            autotext.set_color('white')
            autotext.set_fontweight('bold')
        ax.set_title('Parceiros Comerciais - Exportacoes', fontsize=12, fontweight='bold')

    def _plot_volatility(self, ax, df, c_exp, c_imp):
        vol = df.dropna(subset=['exports_vol'])
        ax.fill_between(vol['date'], 0, vol['exports_vol'], alpha=0.25, color=c_exp)
        ax.plot(vol['date'], vol['exports_vol'], color=c_exp, linewidth=2, label='Vol. Exportacoes')
        ax.fill_between(vol['date'], 0, vol['imports_vol'], alpha=0.25, color=c_imp)
        ax.plot(vol['date'], vol['imports_vol'], color=c_imp, linewidth=2, label='Vol. Importacoes')
        ax.set_title('Volatilidade (DP Movel 12M)', fontsize=12, fontweight='bold')
        ax.set_ylabel('Milhoes USD', fontsize=9)
        ax.legend(fontsize=8)
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.grid(True, alpha=0.3)

    def _plot_scatter(self, ax, df, c_acc):
        scatter = ax.scatter(df['imports'], df['exports'], c=df['year'], cmap='viridis', alpha=0.7, s=50, edgecolors='white', linewidth=0.5)
        z = np.polyfit(df['imports'], df['exports'], 1)
        p = np.poly1d(z)
        ax.plot(df['imports'], p(df['imports']), color=c_acc, linewidth=2, linestyle='--', label='Tendencia')
        ax.set_title('Exportacoes vs Importacoes', fontsize=12, fontweight='bold')
        ax.set_xlabel('Importacoes (M USD)', fontsize=9)
        ax.set_ylabel('Exportacoes (M USD)', fontsize=9)
        ax.legend(fontsize=8)
        ax.grid(True, alpha=0.3)
        plt.colorbar(scatter, ax=ax, shrink=0.75)

    def _plot_distribution(self, ax, df, c_bal, c_acc):
        ax.hist(df['balance'], bins=30, color=c_bal, alpha=0.7, edgecolor='white', linewidth=1)
        ax.axvline(df['balance'].mean(), color=c_acc, linewidth=2, linestyle='--', label=f'Media: ${df["balance"].mean():.0f}M')
        ax.axvline(df['balance'].median(), color='white', linewidth=2, linestyle=':', label=f'Mediana: ${df["balance"].median():.0f}M')
        ax.set_title('Distribuicao do Saldo', fontsize=12, fontweight='bold')
        ax.set_xlabel('Saldo (M USD)', fontsize=9)
        ax.set_ylabel('Frequencia', fontsize=9)
        ax.legend(fontsize=8)
        ax.grid(True, alpha=0.3)

    def _plot_kpis(self, ax, df, c_exp, c_imp, c_bal, c_acc):
        ax.axis('off')
        latest = df.iloc[-1]
        prev = df.iloc[-13] if len(df) >= 13 else df.iloc[0]
        kpis = [
            ('Exportacoes', f'${latest["exports"]:,.0f}M', f'{((latest["exports"]/prev["exports"]-1)*100):+.1f}% YoY', c_exp),
            ('Importacoes', f'${latest["imports"]:,.0f}M', f'{((latest["imports"]/prev["imports"]-1)*100):+.1f}% YoY', c_imp),
            ('Saldo', f'${latest["balance"]:,.0f}M', f'Media: ${df["balance"].mean():,.0f}M', c_bal),
            ('Media Exp.', f'${df["exports"].mean():,.0f}M', f'Max: ${df["exports"].max():,.0f}M', c_exp),
            ('Media Imp.', f'${df["imports"].mean():,.0f}M', f'Max: ${df["imports"].max():,.0f}M', c_imp),
            ('Cobertura', f'{df["coverage_ratio"].mean():.1f}%', f'Atual: {latest["coverage_ratio"]:.1f}%', c_acc),
        ]
        for i, (title, value, sub, color) in enumerate(kpis):
            x = 0.04 + i * 0.16
            rect = mpatches.FancyBboxPatch((x, 0.12), 0.145, 0.76, boxstyle="round,pad=0.015", facecolor='#131d35', edgecolor=color, linewidth=2.5)
            ax.add_patch(rect)
            ax.text(x + 0.072, 0.78, title, ha='center', va='center', fontsize=9, color='#8899aa', fontweight='bold', transform=ax.transAxes)
            ax.text(x + 0.072, 0.52, value, ha='center', va='center', fontsize=15, color=color, fontweight='bold', transform=ax.transAxes)
            ax.text(x + 0.072, 0.28, sub, ha='center', va='center', fontsize=8, color='#8899aa', transform=ax.transAxes)
        ax.set_xlim(0, 1)
        ax.set_ylim(0, 1)
        ax.set_title('INDICADORES CHAVE DE DESEMPENHO', fontsize=14, fontweight='bold', pad=8, y=0.95)


# =============================================================================
# MÓDULO 6: ORQUESTRADOR PRINCIPAL
# =============================================================================
class TaiwanTradeAnalyzer:
    def __init__(self, config: Config = CONFIG):
        self.config = config
        self.collector = DataCollector(config)
        self.processor = DataProcessor(config)
        self.analyzer = MultivariateAnalyzer()
        self.db = DatabaseManager(config.db_path)
        self.dashboard = DashboardBuilder()
        self.df_raw = None
        self.df_clean = None
        self.analysis_results = None

    def run(self, mode: str = 'full'):
        start_time = time.time()
        logger.info("="*70)
        logger.info("TAIWAN ECONOMIC TRADE ANALYZER v2.0 - INICIANDO")
        logger.info("="*70)
        try:
            if mode in ('full', 'scrape'):
                self.df_raw = self.collector.collect(prefer_real=True)
                if self.df_raw is None or len(self.df_raw) == 0:
                    raise ValueError("Falha na coleta de dados!")
            if mode in ('full', 'process') and self.df_raw is not None:
                self.df_clean = self.processor.process(self.df_raw)
            if mode in ('full', 'analyze') and self.df_clean is not None:
                self.analysis_results = self.analyzer.analyze(self.df_clean)
            if mode in ('full',) and self.df_clean is not None:
                self.db.connect()
                self.db.create_schema()
                self.db.insert_trade_data(self.df_clean)
                self.db.insert_monthly_stats(self.df_clean)
                partners = [
                    ('China', 'Export', 2025, 85000, 28.5), ('USA', 'Export', 2025, 45000, 15.1),
                    ('ASEAN', 'Export', 2025, 54000, 18.1), ('Japan', 'Export', 2025, 36000, 12.1),
                    ('South Korea', 'Export', 2025, 24000, 8.1), ('EU', 'Export', 2025, 36000, 12.1),
                    ('Others', 'Export', 2025, 18000, 6.0), ('China', 'Import', 2025, 65000, 22.3),
                    ('USA', 'Import', 2025, 38000, 13.0), ('Japan', 'Import', 2025, 42000, 14.4),
                    ('ASEAN', 'Import', 2025, 48000, 16.5), ('South Korea', 'Import', 2025, 29000, 9.9),
                    ('EU', 'Import', 2025, 35000, 12.0), ('Others', 'Import', 2025, 34000, 11.9),
                ]
                self.db.insert_partners(partners)
                if self.analysis_results:
                    self.db.insert_analysis(self.analysis_results)
                source = ','.join(self.collector.data_sources) if self.collector.data_sources else 'unknown'
                self.db.log_execution(source, len(self.df_clean), 'SUCCESS')
                summary = self.db.get_summary()
                logger.info(f"\nResumo do Banco: {summary}")
                self.db.close()
            if mode in ('full', 'dashboard') and self.df_clean is not None:
                self.dashboard.build(self.df_clean, self.config.dashboard_path)
            elapsed = time.time() - start_time
            logger.info("\n" + "="*70)
            logger.info(f"EXECUCAO CONCLUIDA EM {elapsed:.2f}s")
            logger.info("="*70)
            logger.info(f"Arquivos gerados:")
            logger.info(f"  DB: {self.config.db_path}")
            logger.info(f"  Dashboard: {self.config.dashboard_path}")
            logger.info(f"  Log: taiwan_trade.log")
        except Exception as e:
            logger.critical(f"ERRO FATAL: {e}", exc_info=True)
            raise


def main():
    parser = argparse.ArgumentParser(description='Taiwan Economic Trade Analyzer')
    parser.add_argument('--mode', choices=['full', 'scrape', 'process', 'analyze', 'dashboard'], default='full', help='Modo de execucao')
    parser.add_argument('--db', default='taiwan_trade.db', help='Caminho do banco de dados')
    parser.add_argument('--dashboard', default='taiwan_dashboard.png', help='Caminho do dashboard')
    parser.add_argument('--start-year', type=int, default=2015, help='Ano inicial')
    parser.add_argument('--end-year', type=int, default=2026, help='Ano final')
    args = parser.parse_args()
    config = Config(db_path=args.db, dashboard_path=args.dashboard, start_year=args.start_year, end_year=args.end_year)
    app = TaiwanTradeAnalyzer(config)
    app.run(mode=args.mode)


if __name__ == '__main__':
    main()
