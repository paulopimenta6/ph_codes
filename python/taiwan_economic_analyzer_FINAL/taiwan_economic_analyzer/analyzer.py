"""
Módulo de Análise Estatística Multivariada
Realiza EDA completa, análises estatísticas profundas e séries temporais
"""
import logging
from datetime import datetime
from typing import Dict, List, Tuple, Optional

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from scipy import stats
from scipy.stats import pearsonr, shapiro, jarque_bera, normaltest
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

from config import CONFIG

logger = logging.getLogger("TaiwanAnalyzer")


class StatisticalAnalyzer:
    """
    Analisador estatístico completo para dados econômicos de Taiwan.
    Realiza EDA, análises multivariadas, séries temporais e clustering.
    """

    def __init__(self):
        self.results = {}
        self.figures = {}

    def _valid_series(self, series: pd.Series, min_points: int = 3, min_unique: int = 2) -> bool:
        """Verifica se a serie tem dados suficientes e variacao para testes estatisticos."""
        values = series.dropna()
        return len(values) >= min_points and values.nunique() >= min_unique

    def analyze(self, df: pd.DataFrame) -> Dict:
        """
        Pipeline completo de análise estatística.
        """
        logger.info("\n" + "=" * 70)
        logger.info("ANALISE ESTATISTICA MULTIVARIADA")
        logger.info("=" * 70)

        self.results = {}

        # 1. Estatísticas Descritivas
        self.results['descriptive'] = self._descriptive_stats(df)

        # 2. Análise de Correlação
        self.results['correlation'] = self._correlation_analysis(df)

        # 3. Testes de Normalidade
        self.results['normality'] = self._normality_tests(df)

        # 4. Análise de Tendência
        self.results['trend'] = self._trend_analysis(df)

        # 5. Análise de Sazonalidade
        self.results['seasonality'] = self._seasonality_analysis(df)

        # 6. Análise de Componentes Principais (PCA)
        self.results['pca'] = self._pca_analysis(df)

        # 7. Testes de Estacionariedade
        self.results['stationarity'] = self._stationarity_tests(df)

        # 8. Clustering
        self.results['clustering'] = self._clustering_analysis(df)

        # 9. Análise de Volatilidade
        self.results['volatility'] = self._volatility_analysis(df)

        # 10. Análise de Cointegração
        self.results['cointegration'] = self._cointegration_analysis(df)

        # 11. Forecasting Simples
        self.results['forecast'] = self._simple_forecast(df)

        logger.info("\nAnalise estatistica concluida!")
        return self.results

    def _descriptive_stats(self, df: pd.DataFrame) -> pd.DataFrame:
        """Estatísticas descritivas completas"""
        logger.info("\n[1/11] ESTATISTICAS DESCRITIVAS")

        numeric_cols = ['exports', 'imports', 'balance', 'gdp_growth', 
                       'inflation', 'unemployment', 'industrial_production']
        available_cols = [c for c in numeric_cols if c in df.columns]

        stats_df = df[available_cols].describe().round(2)

        # Adicionar estatísticas adicionais
        additional = pd.DataFrame({
            col: {
                'skewness': round(df[col].skew(), 4),
                'kurtosis': round(df[col].kurtosis(), 4),
                'range': round(df[col].max() - df[col].min(), 2),
                'cv': round(df[col].std() / df[col].mean() * 100, 2) if df[col].mean() != 0 else np.nan
            }
            for col in available_cols
        }).T

        stats_df = pd.concat([stats_df, additional.T])

        logger.info(f"\n{stats_df.to_string()}")
        return stats_df

    def _correlation_analysis(self, df: pd.DataFrame) -> Dict:
        """Análise de correlação completa"""
        logger.info("\n[2/11] ANALISE DE CORRELACAO")

        numeric_cols = ['exports', 'imports', 'balance', 'gdp_growth',
                       'inflation', 'unemployment', 'industrial_production']
        available_cols = [c for c in numeric_cols if c in df.columns]

        corr = df[available_cols].corr()

        logger.info(f"\nMatriz de Correlacao:\n{corr.round(4).to_string()}")

        # Testes de Pearson
        logger.info("\n  Testes de Pearson:")
        pearson_results = {}
        pairs = [(a, b) for i, a in enumerate(available_cols) 
                 for b in available_cols[i+1:]]

        for a, b in pairs:
            a_vals = df[a].dropna()
            b_vals = df[b].dropna()
            if len(a_vals) < 2 or len(b_vals) < 2 or a_vals.nunique() <= 1 or b_vals.nunique() <= 1:
                logger.info(f"    {a} vs {b}: r=nan, p=nan ns (dados constantes ou insuficientes)")
                pearson_results[f"{a}_vs_{b}"] = {'r': np.nan, 'p': np.nan, 'significance': 'ns'}
                continue
            r, p = pearsonr(a_vals, b_vals)
            sig = "***" if p < 0.001 else "**" if p < 0.01 else "*" if p < 0.05 else "ns"
            logger.info(f"    {a} vs {b}: r={r:.4f}, p={p:.6f} {sig}")
            pearson_results[f"{a}_vs_{b}"] = {'r': r, 'p': p, 'significance': sig}

        return {
            'correlation_matrix': corr.to_dict(),
            'pearson_tests': pearson_results
        }

    def _normality_tests(self, df: pd.DataFrame) -> Dict:
        """Testes de normalidade"""
        logger.info("\n[3/11] TESTES DE NORMALIDADE")

        numeric_cols = ['exports', 'imports', 'balance']
        available_cols = [c for c in numeric_cols if c in df.columns]

        results = {}
        for col in available_cols:
            if not self._valid_series(df[col], min_points=3):
                logger.info(f"  {col}: testes ignorados (serie constante ou insuficiente)")
                continue

            # Shapiro-Wilk (amostra limitada a 5000)
            sample = df[col].dropna()
            if len(sample) > 5000:
                sample = sample.sample(5000, random_state=42)

            shapiro_stat, shapiro_p = shapiro(sample)

            # Jarque-Bera
            jb_stat, jb_p = jarque_bera(df[col].dropna())

            # D'Agostino
            dag_stat, dag_p = normaltest(df[col].dropna())

            results[col] = {
                'shapiro_w': shapiro_stat,
                'shapiro_p': shapiro_p,
                'jarque_bera_stat': jb_stat,
                'jarque_bera_p': jb_p,
                'dagostino_stat': dag_stat,
                'dagostino_p': dag_p,
                'normal': shapiro_p > 0.05
            }

            logger.info(f"  {col}:")
            logger.info(f"    Shapiro-Wilk: p={shapiro_p:.6f} ({'Normal' if shapiro_p > 0.05 else 'Nao Normal'})")
            logger.info(f"    Jarque-Bera: p={jb_p:.6f}")
            logger.info(f"    D'Agostino: p={dag_p:.6f}")

        return results

    def _trend_analysis(self, df: pd.DataFrame) -> Dict:
        """Análise de tendência temporal"""
        logger.info("\n[4/11] ANALISE DE TENDENCIA")

        numeric_cols = ['exports', 'imports', 'balance']
        available_cols = [c for c in numeric_cols if c in df.columns]

        X = np.arange(len(df)).reshape(-1, 1)
        trends = {}

        for col in available_cols:
            if not self._valid_series(df[col], min_points=3):
                logger.info(f"  {col}: tendencia ignorada (serie constante ou insuficiente)")
                continue

            model = LinearRegression()
            model.fit(X, df[col])

            # Previsões
            y_pred = model.predict(X)
            residuals = df[col] - y_pred

            trends[col] = {
                'slope': round(model.coef_[0], 4),
                'intercept': round(model.intercept_, 2),
                'r2': round(model.score(X, df[col]), 4),
                'rmse': round(np.sqrt(np.mean(residuals**2)), 2),
                'mae': round(np.mean(np.abs(residuals)), 2),
                'trend_direction': 'Crescente' if model.coef_[0] > 0 else 'Decrescente'
            }

            logger.info(f"  {col}:")
            logger.info(f"    Tendencia: {model.coef_[0]:.2f} unidades/mes")
            logger.info(f"    R2: {model.score(X, df[col]):.4f}")
            logger.info(f"    Direcao: {trends[col]['trend_direction']}")

        return trends

    def _seasonality_analysis(self, df: pd.DataFrame) -> Dict:
        """Análise de sazonalidade"""
        logger.info("\n[5/11] ANALISE DE SAZONALIDADE")

        numeric_cols = ['exports', 'imports', 'balance']
        available_cols = [c for c in numeric_cols if c in df.columns]

        monthly = df.groupby('month')[available_cols].agg(['mean', 'std', 'min', 'max']).round(2)

        logger.info(f"\nEstatisticas Mensais:\n{monthly.to_string()}")

        # Coeficiente de variação sazonal
        cv_seasonal = {}
        for col in available_cols:
            monthly_mean = df.groupby('month')[col].mean()
            cv = monthly_mean.std() / monthly_mean.mean() * 100
            cv_seasonal[col] = round(cv, 2)
            logger.info(f"  {col} CV Sazonal: {cv:.2f}%")

        # Teste de Kruskal-Wallis para sazonalidade
        kruskal_results = {}
        for col in available_cols:
            groups = [df[df['month'] == m][col].dropna().values for m in range(1, 13)]
            groups = [g for g in groups if len(g) > 0]
            if len(groups) <= 1:
                continue
            all_values = np.concatenate(groups)
            if len(np.unique(all_values)) <= 1:
                logger.info(f"  {col} Kruskal-Wallis: ignorado (valores constantes)")
                continue
            try:
                stat, p = stats.kruskal(*groups)
                kruskal_results[col] = {'statistic': stat, 'p_value': p}
                logger.info(f"  {col} Kruskal-Wallis: p={p:.6f} ({'Sazonal' if p < 0.05 else 'Nao Sazonal'})")
            except ValueError as e:
                logger.warning(f"  {col} Kruskal-Wallis ignorado: {e}")

        return {
            'monthly_stats': monthly.to_dict(),
            'cv_seasonal': cv_seasonal,
            'kruskal_wallis': kruskal_results
        }

    def _pca_analysis(self, df: pd.DataFrame) -> Dict:
        """Análise de Componentes Principais"""
        logger.info("\n[6/11] ANALISE DE COMPONENTES PRINCIPAIS (PCA)")

        numeric_cols = ['exports', 'imports', 'balance', 'gdp_growth',
                       'inflation', 'unemployment', 'industrial_production']
        available_cols = [c for c in numeric_cols if c in df.columns]

        X = df[available_cols].dropna()

        if len(X) < 10:
            logger.warning("  Dados insuficientes para PCA")
            return {}

        X_scaled = StandardScaler().fit_transform(X)
        pca = PCA()
        pca.fit(X_scaled)

        logger.info(f"  Variancia explicada:")
        for i, var in enumerate(pca.explained_variance_ratio_):
            logger.info(f"    PC{i+1}: {var*100:.2f}%")

        logger.info(f"  Variancia acumulada: {np.cumsum(pca.explained_variance_ratio_)*100}")

        # Loadings
        loadings = pd.DataFrame(
            pca.components_.T,
            columns=[f'PC{i+1}' for i in range(len(available_cols))],
            index=available_cols
        )

        logger.info(f"\n  Loadings:\n{loadings.round(4).to_string()}")

        return {
            'explained_variance': pca.explained_variance_ratio_.tolist(),
            'cumulative_variance': np.cumsum(pca.explained_variance_ratio_).tolist(),
            'loadings': loadings.to_dict(),
            'n_components': len(available_cols)
        }

    def _stationarity_tests(self, df: pd.DataFrame) -> Dict:
        """Testes de estacionariedade"""
        logger.info("\n[7/11] TESTES DE ESTACIONARIEDADE")

        try:
            from statsmodels.tsa.stattools import adfuller, kpss

            numeric_cols = ['exports', 'imports', 'balance']
            available_cols = [c for c in numeric_cols if c in df.columns]

            results = {}
            for col in available_cols:
                series = df[col].dropna()
                if not self._valid_series(series, min_points=4):
                    logger.info(f"  {col}: testes ignorados (serie constante ou insuficiente)")
                    continue

                try:
                    adf_result = adfuller(series)
                except ValueError as e:
                    logger.warning(f"  {col} ADF ignorado: {e}")
                    continue

                # KPSS Test
                try:
                    kpss_result = kpss(series, regression='c')
                except Exception:
                    kpss_result = (None, None, None, None)

                results[col] = {
                    'adf_stat': round(adf_result[0], 4),
                    'adf_p_value': round(adf_result[1], 6),
                    'adf_stationary': adf_result[1] < 0.05,
                    'kpss_stat': round(kpss_result[0], 4) if kpss_result[0] else None,
                    'kpss_p_value': round(kpss_result[1], 6) if kpss_result[1] else None,
                    'kpss_stationary': kpss_result[1] > 0.05 if kpss_result[1] else None
                }

                logger.info(f"  {col}:")
                logger.info(f"    ADF: stat={adf_result[0]:.4f}, p={adf_result[1]:.6f} ({'Estacionaria' if adf_result[1] < 0.05 else 'Nao Estacionaria'})")
                if kpss_result[1]:
                    logger.info(f"    KPSS: stat={kpss_result[0]:.4f}, p={kpss_result[1]:.6f}")

            return results
        except ImportError:
            logger.warning("  statsmodels nao instalado - pulando testes de estacionariedade")
            return {}

    def _clustering_analysis(self, df: pd.DataFrame) -> Dict:
        """Análise de clustering"""
        logger.info("\n[8/11] ANALISE DE CLUSTERING")

        numeric_cols = ['exports', 'imports', 'balance']
        available_cols = [c for c in numeric_cols if c in df.columns]

        features = df[available_cols].dropna()

        if len(features) < 12:
            logger.warning("  Dados insuficientes para clustering")
            return {}

        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(features)

        # Determinar número ótimo de clusters
        best_k = 3
        best_score = -1

        for k in range(2, min(6, len(features) // 3)):
            kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
            clusters = kmeans.fit_predict(X_scaled)
            score = silhouette_score(X_scaled, clusters)
            if score > best_score:
                best_score = score
                best_k = k

        kmeans = KMeans(n_clusters=best_k, random_state=42, n_init=10)
        clusters = kmeans.fit_predict(X_scaled)

        df.loc[features.index, 'cluster'] = clusters

        cluster_summary = df.groupby('cluster')[available_cols].agg(['mean', 'std', 'count']).round(2)

        logger.info(f"  Numero otimo de clusters: {best_k}")
        logger.info(f"  Silhouette Score: {best_score:.4f}")
        logger.info(f"\n  Resumo dos Clusters:\n{cluster_summary.to_string()}")

        return {
            'n_clusters': best_k,
            'silhouette_score': best_score,
            'clusters': clusters.tolist(),
            'centers': kmeans.cluster_centers_.tolist(),
            'cluster_summary': cluster_summary.to_dict()
        }

    def _volatility_analysis(self, df: pd.DataFrame) -> Dict:
        """Análise de volatilidade"""
        logger.info("\n[9/11] ANALISE DE VOLATILIDADE")

        results = {}
        for col in ['exports', 'imports', 'balance']:
            if col not in df.columns:
                continue
            if not self._valid_series(df[col], min_points=4):
                logger.info(f"  {col}: volatilidade ignorada (serie constante ou insuficiente)")
                continue

            # Volatilidade rolling
            vol = df[col].rolling(12).std()

            # GARCH-like simples (volatilidade condicional)
            returns = df[col].pct_change().dropna()

            results[col] = {
                'mean_volatility': round(vol.mean(), 2),
                'max_volatility': round(vol.max(), 2),
                'min_volatility': round(vol.min(), 2),
                'volatility_of_volatility': round(vol.std(), 2),
                'return_mean': round(returns.mean() * 100, 4),
                'return_std': round(returns.std() * 100, 4),
                'return_skewness': round(returns.skew(), 4),
                'return_kurtosis': round(returns.kurtosis(), 4)
            }

            logger.info(f"  {col}:")
            logger.info(f"    Volatilidade media: {vol.mean():.2f}")
            logger.info(f"    Retorno medio: {returns.mean()*100:.4f}%")
            logger.info(f"    Retorno std: {returns.std()*100:.4f}%")

        return results

    def _cointegration_analysis(self, df: pd.DataFrame) -> Dict:
        """Análise de cointegração"""
        logger.info("\n[10/11] ANALISE DE COINTEGRACAO")

        try:
            from statsmodels.tsa.stattools import coint

            if 'exports' in df.columns and 'imports' in df.columns:
                score, p_value, crit_values = coint(df['exports'], df['imports'])

                logger.info(f"  Exports vs Imports:")
                logger.info(f"    Score: {score:.4f}")
                logger.info(f"    p-value: {p_value:.6f}")
                logger.info(f"    Cointegrados: {'Sim' if p_value < 0.05 else 'Nao'}")

                return {
                    'exports_vs_imports': {
                        'score': score,
                        'p_value': p_value,
                        'cointegrated': p_value < 0.05,
                        'critical_values': crit_values.tolist()
                    }
                }
        except ImportError:
            logger.warning("  statsmodels nao instalado - pulando cointegracao")

        return {}

    def _simple_forecast(self, df: pd.DataFrame) -> Dict:
        """Forecasting simples usando médias móveis e tendência"""
        logger.info("\n[11/11] FORECASTING SIMPLES")

        forecasts = {}

        for col in ['exports', 'imports', 'balance']:
            if col not in df.columns:
                continue
            if not self._valid_series(df[col], min_points=4):
                logger.info(f"  {col}: forecast ignorado (serie constante ou insuficiente)")
                continue

            data = df[col].dropna()

            # Método 1: Média móvel
            ma_forecast = data.rolling(12).mean().iloc[-1]

            # Método 2: Tendência linear
            X = np.arange(len(data)).reshape(-1, 1)
            model = LinearRegression()
            model.fit(X, data)
            next_period = len(data)
            trend_forecast = model.predict([[next_period]])[0]

            # Método 3: Drift (média dos últimos 12 meses)
            drift = data.iloc[-12:].mean() - data.iloc[-24:-12].mean()
            drift_forecast = data.iloc[-1] + drift

            forecasts[col] = {
                'last_value': round(data.iloc[-1], 2),
                'ma_forecast': round(ma_forecast, 2),
                'trend_forecast': round(trend_forecast, 2),
                'drift_forecast': round(drift_forecast, 2),
                'combined_forecast': round((ma_forecast + trend_forecast + drift_forecast) / 3, 2)
            }

            logger.info(f"  {col}:")
            logger.info(f"    Ultimo valor: {data.iloc[-1]:.2f}")
            logger.info(f"    Previsao MA: {ma_forecast:.2f}")
            logger.info(f"    Previsao Tendencia: {trend_forecast:.2f}")
            logger.info(f"    Previsao Combinada: {forecasts[col]['combined_forecast']:.2f}")

        return forecasts

    def generate_analysis_report(self, df: pd.DataFrame) -> str:
        """Gera relatório completo em texto"""
        report = []
        report.append("=" * 70)
        report.append("RELATORIO DE ANALISE ESTATISTICA - TAIWAN")
        report.append("=" * 70)
        report.append(f"Data: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"Periodo: {df['date'].min().strftime('%Y-%m-%d')} a {df['date'].max().strftime('%Y-%m-%d')}")
        report.append(f"Registros: {len(df)}")
        report.append("")

        # Resumo descritivo
        report.append("--- ESTATISTICAS DESCRITIVAS ---")
        if 'descriptive' in self.results:
            desc = self.results['descriptive']
            report.append(desc.to_string())

        report.append("")
        report.append("--- TENDENCIAS ---")
        if 'trend' in self.results:
            for col, vals in self.results['trend'].items():
                report.append(f"{col}: Tendencia={vals['slope']:.2f}, R2={vals['r2']:.4f}")

        report.append("")
        report.append("--- FORECAST ---")
        if 'forecast' in self.results:
            for col, vals in self.results['forecast'].items():
                report.append(f"{col}: Previsao Combinada={vals['combined_forecast']:.2f}")

        return "\n".join(report)
