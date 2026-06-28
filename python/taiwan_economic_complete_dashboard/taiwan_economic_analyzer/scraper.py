"""
Modulo de Web Scraping para Indicadores Economicos de Taiwan
Inclui fontes: Trading Economics, World Bank, IMF e MOEA Taiwan
"""
import os
import sys
import json
import time
import logging
import re
from datetime import datetime, timedelta
from typing import Optional, Dict, List, Tuple
from dataclasses import dataclass

import numpy as np
import pandas as pd
import requests
from bs4 import BeautifulSoup

from config import CONFIG

logger = logging.getLogger("TaiwanScraper")


@dataclass
class ScrapeResult:
    df: pd.DataFrame
    source: str
    timestamp: datetime
    records_count: int
    success: bool
    message: str = ""


class TaiwanDataScraper:
    """Scraper robusto para dados economicos de Taiwan com multiplas fontes."""

    def __init__(self, config=CONFIG):
        self.config = config
        self.session = self._create_session()
        self.data_sources_used = []

    def _create_session(self) -> requests.Session:
        session = requests.Session()
        session.headers.update({
            'User-Agent': self.config.USER_AGENT,
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.5',
            'Accept-Encoding': 'gzip, deflate, br',
            'DNT': '1',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1'
        })
        return session

    def _fetch_with_retry(self, url: str, method: str = 'get', **kwargs) -> Optional[str]:
        for attempt in range(self.config.MAX_RETRIES):
            try:
                if method.lower() == 'get':
                    response = self.session.get(url, timeout=self.config.REQUEST_TIMEOUT, **kwargs)
                else:
                    response = self.session.post(url, **kwargs)
                response.raise_for_status()
                if len(response.content) < 500:
                    logger.warning(f"Resposta curta: {len(response.content)} bytes")
                    if attempt < self.config.MAX_RETRIES - 1:
                        time.sleep(self.config.RETRY_DELAY * (attempt + 1))
                        continue
                return response.text
            except requests.exceptions.RequestException as e:
                logger.error(f"Erro {url} (tentativa {attempt + 1}): {e}")
                if attempt < self.config.MAX_RETRIES - 1:
                    time.sleep(self.config.RETRY_DELAY * (attempt + 1))
                else:
                    return None
        return None

    # =========================================================================
    # FONTE 1: Trading Economics
    # =========================================================================
    def scrape_trading_economics(self) -> Optional[pd.DataFrame]:
        logger.info("[FONTE 1] Trading Economics...")
        indicators = {
            'exports': 'https://tradingeconomics.com/taiwan/exports',
            'imports': 'https://tradingeconomics.com/taiwan/imports',
            'balance': 'https://tradingeconomics.com/taiwan/balance-of-trade',
            'gdp_growth': 'https://tradingeconomics.com/taiwan/gdp-growth',
            'inflation': 'https://tradingeconomics.com/taiwan/inflation-cpi',
            'unemployment': 'https://tradingeconomics.com/taiwan/unemployment-rate',
            'interest_rate': 'https://tradingeconomics.com/taiwan/interest-rate',
        }
        all_data = []
        for indicator_name, url in indicators.items():
            html = self._fetch_with_retry(url)
            if html is None:
                continue
            try:
                soup = BeautifulSoup(html, 'html.parser')
                records = []
                tables = soup.find_all('table')
                logger.info(f"  {indicator_name}: {len(tables)} tabelas encontradas")
                for table in tables:
                    rows = table.find_all('tr')
                    for row in rows[1:]:
                        cells = row.find_all(['td', 'th'])
                        if len(cells) >= 2:
                            date_text = cells[0].get_text(strip=True)
                            value_text = cells[1].get_text(strip=True)
                            value_text = re.sub(r'[^\d.\-]', '', value_text)
                            try:
                                date = self._parse_date(date_text)
                                if date is not None and pd.notna(date) and value_text:
                                    value = float(value_text)
                                    records.append({'date': date, indicator_name: value})
                            except (ValueError, TypeError):
                                continue
                if not records:
                    scripts = soup.find_all('script')
                    for script in scripts:
                        text = script.get_text()
                        if 'historicalData' in text or 'chartData' in text:
                            json_match = re.search(r'\[\s*\{.*?\}\s*\]', text, re.DOTALL)
                            if json_match:
                                try:
                                    data_json = json.loads(json_match.group())
                                    for item in data_json:
                                        if 'date' in item and 'value' in item:
                                            date = pd.to_datetime(item['date'], errors='coerce')
                                            if pd.notna(date):
                                                records.append({
                                                    'date': date,
                                                    indicator_name: float(item['value'])
                                                })
                                except:
                                    pass
                if records:
                    df_ind = pd.DataFrame(records)
                    df_ind = df_ind.drop_duplicates(subset=['date']).sort_values('date')
                    logger.info(f"  OK {indicator_name}: {len(df_ind)} registros")
                    all_data.append(df_ind)
                else:
                    logger.warning(f"  Nenhum dado encontrado para {indicator_name}")
            except Exception as e:
                logger.error(f"  ERRO {indicator_name}: {e}")
        if not all_data:
            return None
        df_final = all_data[0]
        for df_next in all_data[1:]:
            df_final = pd.merge(df_final, df_next, on='date', how='outer')
        df_final = self._normalize_to_monthly(df_final)
        df_final['source'] = 'trading_economics'
        logger.info(f"OK Trading Economics: {len(df_final)} registros consolidados")
        return df_final

    # =========================================================================
    # FONTE 2: World Bank API
    # =========================================================================
    def fetch_world_bank(self) -> Optional[pd.DataFrame]:
        logger.info("[FONTE 2] World Bank API...")
        indicators = {
            'exports': 'NE.EXP.GNFS.CD', 'imports': 'NE.IMP.GNFS.CD',
            'balance': 'BN.CAB.XOKA.CD', 'gdp_growth': 'NY.GDP.MKTP.KD.ZG',
            'inflation': 'FP.CPI.TOTL.ZG', 'unemployment': 'SL.UEM.TOTL.ZS',
        }
        data_dict = {k: [] for k in indicators.keys()}
        for indicator_name, indicator_code in indicators.items():
            url = f"https://api.worldbank.org/v2/country/TWN/indicator/{indicator_code}"
            params = {'format': 'json', 'date': f'{self.config.START_YEAR}:{self.config.END_YEAR}', 'per_page': 500}
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
                            data_dict[indicator_name].append({
                                'date': pd.to_datetime(f'{year}-06-15'),
                                indicator_name: float(value) / 1e6 if indicator_name in ['exports', 'imports', 'balance'] else float(value)
                            })
                    logger.info(f"  OK {indicator_name}: {len(data_dict[indicator_name])} registros")
            except Exception as e:
                logger.error(f"  ERRO {indicator_name}: {e}")
        return self._consolidate_dict_data(data_dict, 'world_bank')

    # =========================================================================
    # FONTE 3: IMF Data
    # =========================================================================
    def fetch_imf_data(self) -> Optional[pd.DataFrame]:
        logger.info("[FONTE 3] IMF Data...")
        indicators = {'exports': 'TXG_FOB_USD', 'imports': 'TMG_CIF_USD'}
        data_dict = {'exports': [], 'imports': [], 'balance': []}
        for indicator_name, indicator_code in indicators.items():
            url = f"https://data.imf.org/api/data/DOT/{indicator_code}"
            params = {'freq': 'M', 'period': f'{self.config.START_YEAR}-01:{self.config.END_YEAR}-12'}
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
                            data_dict[indicator_name].append({'date': pd.to_datetime(period), indicator_name: float(value)})
                logger.info(f"  OK {indicator_name}: {len(data_dict[indicator_name])} registros")
            except Exception as e:
                logger.error(f"  ERRO {indicator_name}: {e}")
        if data_dict['exports'] and data_dict['imports']:
            df_exp = pd.DataFrame(data_dict['exports']).set_index('date')
            df_imp = pd.DataFrame(data_dict['imports']).set_index('date')
            df_merged = df_exp.join(df_imp, how='outer')
            df_merged['balance'] = df_merged['exports'] - df_merged['imports']
            df_merged = df_merged.reset_index().sort_values('date').reset_index(drop=True)
            df_merged['year'] = df_merged['date'].dt.year
            df_merged['month'] = df_merged['date'].dt.month
            df_merged['source'] = 'imf'
            return df_merged
        return None

    # =========================================================================
    # FONTE 4: MOEA Taiwan (Ministry of Economic Affairs)
    # =========================================================================
    def scrape_moea_taiwan(self) -> Optional[pd.DataFrame]:
        """
        Extrai dados do MOEA Taiwan (Ministerio de Assuntos Economicos).
        Fonte oficial do governo taiwanes para estatisticas de comercio.
        """
        logger.info("[FONTE 4] MOEA Taiwan...")

        # URLs do MOEA para estatisticas de comercio
        moea_urls = {
            'trade_summary': 'https://www.moea.gov.tw/Mns/dos/bulletin/Bulletin.aspx?kind=9&html=1&menu_id=18808&bull_id=3605',
            'export_by_product': 'https://www.moea.gov.tw/Mns/dos/bulletin/Bulletin.aspx?kind=9&html=1&menu_id=18808&bull_id=3606',
            'import_by_product': 'https://www.moea.gov.tw/Mns/dos/bulletin/Bulletin.aspx?kind=9&html=1&menu_id=18808&bull_id=3607',
        }

        all_records = []

        for page_name, url in moea_urls.items():
            html = self._fetch_with_retry(url)
            if html is None:
                continue

            try:
                soup = BeautifulSoup(html, 'html.parser')

                # Estrategia 1: Buscar tabelas de dados
                tables = soup.find_all('table', {'class': ['table', 'data-table', 'stat-table']})

                for table in tables:
                    rows = table.find_all('tr')
                    for row in rows[1:]:  # Pular header
                        cells = row.find_all(['td', 'th'])
                        if len(cells) >= 3:
                            # Extrair data (geralmente primeira coluna)
                            date_text = cells[0].get_text(strip=True)

                            # Tentar extrair valores de exportacao/importacao
                            try:
                                date = self._parse_date(date_text)
                                if date is None:
                                    continue

                                record = {'date': date}

                                # Extrair valores numericos das colunas seguintes
                                for i, cell in enumerate(cells[1:], 1):
                                    val_text = cell.get_text(strip=True)
                                    val_text = re.sub(r'[^\d.\-]', '', val_text)
                                    if val_text:
                                        try:
                                            val = float(val_text)
                                            # Mapear colunas baseado no nome da pagina
                                            if page_name == 'trade_summary':
                                                if i == 1:
                                                    record['total_exports'] = val
                                                elif i == 2:
                                                    record['total_imports'] = val
                                                elif i == 3:
                                                    record['trade_balance'] = val
                                            elif page_name == 'export_by_product':
                                                if i == 1:
                                                    record['electronic_exports'] = val
                                                elif i == 2:
                                                    record['machinery_exports'] = val
                                                elif i == 3:
                                                    record['chemicals_exports'] = val
                                            elif page_name == 'import_by_product':
                                                if i == 1:
                                                    record['electronic_imports'] = val
                                                elif i == 2:
                                                    record['machinery_imports'] = val
                                        except ValueError:
                                            pass

                                if len(record) > 1:  # Pelo menos data + 1 valor
                                    all_records.append(record)

                            except Exception as e:
                                logger.debug(f"Erro ao processar linha MOEA: {e}")
                                continue

                # Estrategia 2: Buscar dados em formato JSON/API embutido
                if not all_records:
                    scripts = soup.find_all('script')
                    for script in scripts:
                        text = script.get_text()
                        if 'chartData' in text or 'tradeData' in text:
                            json_matches = re.findall(r'\[\s*\{[^{}]*\}\s*\]', text)
                            for match in json_matches:
                                try:
                                    data_json = json.loads(match)
                                    for item in data_json:
                                        if 'date' in item:
                                            record = {'date': pd.to_datetime(item['date'])}
                                            for key, val in item.items():
                                                if key != 'date' and isinstance(val, (int, float)):
                                                    record[key] = float(val)
                                            if len(record) > 1:
                                                all_records.append(record)
                                except:
                                    pass

                logger.info(f"  {page_name}: {len(all_records)} registros processados")

            except Exception as e:
                logger.error(f"  ERRO MOEA {page_name}: {e}")

        if not all_records:
            logger.warning("  Nenhum dado MOEA encontrado")
            return None

        # Consolidar todos os registros
        df_moea = pd.DataFrame(all_records)
        df_moea = df_moea.drop_duplicates(subset=['date']).sort_values('date')
        df_moea['year'] = df_moea['date'].dt.year
        df_moea['month'] = df_moea['date'].dt.month

        # Calcular totais se nao existirem
        if 'trade_balance' not in df_moea.columns and 'total_exports' in df_moea.columns and 'total_imports' in df_moea.columns:
            df_moea['trade_balance'] = df_moea['total_exports'] - df_moea['total_imports']

        logger.info(f"OK MOEA Taiwan: {len(df_moea)} registros consolidados")
        return df_moea

    # =========================================================================
    # FONTE 5: Dados Simulados (Fallback)
    # =========================================================================
    def generate_simulated_data(self, seed: int = 42) -> pd.DataFrame:
        logger.info("[FONTE 5] Dados simulados (Fallback)...")
        np.random.seed(seed)
        start_date = datetime(self.config.START_YEAR, 1, 1)
        end_date = datetime(self.config.END_YEAR, 6, 1)
        dates = pd.date_range(start=start_date, end=end_date, freq='MS')
        n_months = len(dates)

        # Tendencia crescente
        trend = np.linspace(22000, 45000, n_months)
        seasonal = (3000 * np.sin(2 * np.pi * np.arange(n_months) / 12) + 
                   1500 * np.sin(4 * np.pi * np.arange(n_months) / 12))
        cycle = 2500 * np.sin(2 * np.pi * np.arange(n_months) / 60)

        # Choques economicos
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

        # Indicadores economicos
        gdp_growth = 2.5 + 1.5 * np.sin(2 * np.pi * np.arange(n_months) / 48) + np.random.normal(0, 0.8, n_months)
        gdp_growth[covid_start:covid_end] -= np.linspace(3, 1, covid_end - covid_start)
        inflation = 1.5 + 0.8 * np.sin(2 * np.pi * np.arange(n_months) / 36) + np.random.normal(0, 0.3, n_months)
        inflation = np.clip(inflation, -1, 5)
        unemployment = 3.5 + 0.5 * np.sin(2 * np.pi * np.arange(n_months) / 60) + np.random.normal(0, 0.2, n_months)
        unemployment[covid_start:covid_end] += np.linspace(0.5, 1.2, covid_end - covid_start)
        unemployment = np.clip(unemployment, 2.5, 6.5)
        industrial_prod = 100 + 5 * np.sin(2 * np.pi * np.arange(n_months) / 12) + np.random.normal(0, 3, n_months)
        industrial_prod[covid_start:covid_end] -= np.linspace(15, 5, covid_end - covid_start)
        interest_rate = 1.5 + 0.5 * np.sin(2 * np.pi * np.arange(n_months) / 72) + np.random.normal(0, 0.1, n_months)
        interest_rate = np.clip(interest_rate, 0.5, 3.0)
        exchange_rate = 30 + 2 * np.sin(2 * np.pi * np.arange(n_months) / 48) + np.random.normal(0, 0.5, n_months)

        # Dados MOEA simulados - setores especificos
        electronic_exports = exports * 0.35 + np.random.normal(0, 500, n_months)
        machinery_exports = exports * 0.15 + np.random.normal(0, 300, n_months)
        chemicals_exports = exports * 0.08 + np.random.normal(0, 200, n_months)
        textiles_exports = exports * 0.05 + np.random.normal(0, 150, n_months)
        steel_exports = exports * 0.06 + np.random.normal(0, 180, n_months)
        plastic_exports = exports * 0.04 + np.random.normal(0, 120, n_months)
        mineral_exports = exports * 0.03 + np.random.normal(0, 100, n_months)
        info_tech_exports = electronic_exports * 0.45 + np.random.normal(0, 300, n_months)
        optoelectronic_exports = electronic_exports * 0.25 + np.random.normal(0, 200, n_months)
        semiconductor_exports = electronic_exports * 0.30 + np.random.normal(0, 250, n_months)

        df = pd.DataFrame({
            'date': dates, 'year': dates.year, 'month': dates.month,
            'exports': np.round(exports, 2), 'imports': np.round(imports, 2),
            'balance': np.round(balance, 2), 'gdp_growth': np.round(gdp_growth, 2),
            'inflation': np.round(inflation, 2), 'unemployment': np.round(unemployment, 2),
            'industrial_production': np.round(industrial_prod, 2),
            'interest_rate': np.round(interest_rate, 2),
            'exchange_rate': np.round(exchange_rate, 2),
            # Dados MOEA
            'total_exports': np.round(exports, 2),
            'total_imports': np.round(imports, 2),
            'trade_balance': np.round(balance, 2),
            'electronic_exports': np.round(electronic_exports, 2),
            'machinery_exports': np.round(machinery_exports, 2),
            'chemicals_exports': np.round(chemicals_exports, 2),
            'textiles_exports': np.round(textiles_exports, 2),
            'steel_exports': np.round(steel_exports, 2),
            'plastic_exports': np.round(plastic_exports, 2),
            'mineral_exports': np.round(mineral_exports, 2),
            'info_tech_exports': np.round(info_tech_exports, 2),
            'optoelectronic_exports': np.round(optoelectronic_exports, 2),
            'semiconductor_exports': np.round(semiconductor_exports, 2),
            'source': 'simulated'
        })

        # Adicionar missing e outliers para testar pipeline
        missing_idx = np.random.choice(df.index, size=int(0.03 * len(df)), replace=False)
        df.loc[missing_idx, 'exports'] = np.nan
        missing_idx2 = np.random.choice(df.index, size=int(0.02 * len(df)), replace=False)
        df.loc[missing_idx2, 'imports'] = np.nan
        outlier_idx = np.random.choice(df.index, size=5, replace=False)
        df.loc[outlier_idx, 'exports'] *= np.random.choice([2.5, 0.2], size=5)
        outlier_idx2 = np.random.choice(df.index, size=3, replace=False)
        df.loc[outlier_idx2, 'imports'] *= np.random.choice([2.8, 0.15], size=3)

        logger.info(f"  OK Simulado: {len(df)} registros")
        return df

    def _parse_date(self, date_text: str) -> Optional[pd.Timestamp]:
        if not date_text or not str(date_text).strip():
            return None
        formats = ['%Y-%m-%d', '%b/%y', '%b %Y', '%m/%d/%Y', '%d/%m/%Y', '%Y', '%B %Y']
        for fmt in formats:
            try:
                parsed = pd.to_datetime(date_text, format=fmt)
                if pd.notna(parsed):
                    return parsed
            except (ValueError, TypeError):
                continue
        parsed = pd.to_datetime(date_text, errors='coerce')
        return parsed if pd.notna(parsed) else None

    def _normalize_to_monthly(self, df: pd.DataFrame) -> pd.DataFrame:
        """Normaliza datas irregulares para inicio do mes e remove registros invalidos."""
        df = df.copy()
        df['date'] = pd.to_datetime(df['date'], errors='coerce')
        before = len(df)
        df = df.dropna(subset=['date'])
        removed = before - len(df)
        if removed:
            logger.info(f"  {removed} registros com data invalida removidos")

        meta_cols = {'date', 'year', 'month', 'source'}
        numeric_cols = [
            c for c in df.columns
            if c not in meta_cols and pd.api.types.is_numeric_dtype(df[c])
        ]
        if not numeric_cols:
            numeric_cols = [c for c in df.columns if c not in meta_cols]

        df['date'] = df['date'].dt.to_period('M').dt.to_timestamp()
        df = df.groupby('date', as_index=False)[numeric_cols].mean(numeric_only=True)
        df = df.sort_values('date').reset_index(drop=True)
        df['year'] = df['date'].dt.year
        df['month'] = df['date'].dt.month
        return df

    def _consolidate_dict_data(self, data_dict: Dict, source_name: str) -> Optional[pd.DataFrame]:
        dfs = []
        for indicator, records in data_dict.items():
            if records:
                df_ind = pd.DataFrame(records)
                df_ind = df_ind.drop_duplicates(subset=['date'])
                dfs.append(df_ind.set_index('date'))
        if not dfs:
            return None
        df_merged = dfs[0]
        for df_next in dfs[1:]:
            df_merged = df_merged.join(df_next, how='outer')
        df_merged = df_merged.reset_index().sort_values('date').reset_index(drop=True)
        df_merged['year'] = df_merged['date'].dt.year
        df_merged['month'] = df_merged['date'].dt.month
        if 'balance' not in df_merged.columns and 'exports' in df_merged.columns and 'imports' in df_merged.columns:
            df_merged['balance'] = df_merged['exports'] - df_merged['imports']
        df_merged['source'] = source_name
        return df_merged

    def _is_dataset_usable(self, df: pd.DataFrame) -> Tuple[bool, str]:
        """Valida se o dataset real tem dados minimos para o pipeline."""
        min_records = 12
        min_trade_values = 6

        if df is None or len(df) < min_records:
            return False, f"poucos registros ({0 if df is None else len(df)} < {min_records})"

        if not {'exports', 'imports'}.issubset(df.columns):
            return False, "colunas exports/imports ausentes"

        exports_count = int(df['exports'].notna().sum())
        imports_count = int(df['imports'].notna().sum())
        if exports_count < min_trade_values or imports_count < min_trade_values:
            return False, (
                f"dados de comercio insuficientes "
                f"(exports={exports_count}, imports={imports_count}, minimo={min_trade_values})"
            )

        return True, ""

    def collect(self, prefer_real: bool = True) -> ScrapeResult:
        logger.info("=" * 70)
        logger.info("COLETA DE DADOS")
        logger.info("=" * 70)
        sources = [
            ('Trading Economics', self.scrape_trading_economics),
            ('World Bank', self.fetch_world_bank),
            ('IMF Data', self.fetch_imf_data),
            ('MOEA Taiwan', self.scrape_moea_taiwan),
        ]
        if prefer_real:
            for name, func in sources:
                try:
                    df = func()
                    usable, reason = self._is_dataset_usable(df)
                    if usable:
                        logger.info(f"OK Fonte '{name}' utilizada: {len(df)} registros")
                        self.data_sources_used.append(name)
                        return ScrapeResult(df=df, source=name, timestamp=datetime.now(),
                                           records_count=len(df), success=True)
                    if df is not None and len(df) > 0:
                        logger.warning(f"Fonte '{name}' rejeitada: {reason}")
                except Exception as e:
                    logger.error(f"ERRO Fonte '{name}': {e}")
        logger.warning("Todas as fontes reais falharam. Usando simulado.")
        self.data_sources_used.append('simulated')
        df = self.generate_simulated_data()
        return ScrapeResult(df=df, source='simulated', timestamp=datetime.now(),
                           records_count=len(df), success=True,
                           message="Dados simulados utilizados como fallback")
