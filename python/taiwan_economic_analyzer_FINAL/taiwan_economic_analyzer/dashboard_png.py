"""
Módulo de Dashboard em PNG
Gera visualizações estáticas usando Matplotlib
"""
import logging
from datetime import datetime
from typing import Optional

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import matplotlib.patches as mpatches
from matplotlib.gridspec import GridSpec

from config import CONFIG

logger = logging.getLogger("TaiwanDashboardPNG")


class DashboardBuilder:
    """
    Construtor de dashboard em PNG para dados econômicos de Taiwan.
    """

    def __init__(self):
        self._setup_style()

    def _setup_style(self):
        """Configura estilo visual do dashboard"""
        plt.rcParams['figure.facecolor'] = '#0a0e27'
        plt.rcParams['axes.facecolor'] = '#0f1535'
        plt.rcParams['axes.edgecolor'] = '#2a3f5f'
        plt.rcParams['axes.labelcolor'] = '#a0aec0'
        plt.rcParams['text.color'] = '#e2e8f0'
        plt.rcParams['xtick.color'] = '#a0aec0'
        plt.rcParams['ytick.color'] = '#a0aec0'
        plt.rcParams['grid.color'] = '#1e293b'
        plt.rcParams['grid.alpha'] = 0.5
        plt.rcParams['axes.grid'] = True
        plt.rcParams['grid.linestyle'] = '--'
        plt.rcParams['grid.linewidth'] = 0.5

    def build(self, df: pd.DataFrame, analysis_results: Optional[dict] = None,
              save_path: str = CONFIG.DASHBOARD_PNG_PATH):
        """
        Constrói o dashboard completo em PNG.
        """
        logger.info("\n" + "=" * 70)
        logger.info("CONSTRUINDO DASHBOARD PNG")
        logger.info("=" * 70)

        fig = plt.figure(figsize=(28, 40))
        gs = GridSpec(7, 3, figure=fig, hspace=0.40, wspace=0.30)

        # Cores
        C_EXP = '#00d4aa'
        C_IMP = '#ff6b6b'
        C_BAL = '#4dabf7'
        C_ACC = '#ffd43b'
        C_GDP = '#da77f2'
        C_INF = '#ff922b'

        # 1. Série Temporal Principal
        ax1 = fig.add_subplot(gs[0, :])
        self._plot_timeseries(ax1, df, C_EXP, C_IMP, C_BAL, C_ACC)

        # 2. YoY Charts
        ax2 = fig.add_subplot(gs[1, 0])
        self._plot_yoy(ax2, df, 'exports_yoy', 'Exportacoes YoY (%)', C_EXP, C_IMP)
        ax2b = fig.add_subplot(gs[1, 1])
        self._plot_yoy(ax2b, df, 'imports_yoy', 'Importacoes YoY (%)', C_EXP, C_IMP)
        ax2c = fig.add_subplot(gs[1, 2])
        self._plot_yoy(ax2c, df, 'balance_yoy', 'Saldo YoY (%)', C_EXP, C_IMP)

        # 3. Sazonalidade e Correlação
        ax3 = fig.add_subplot(gs[2, 0])
        self._plot_seasonality(ax3, df, C_EXP, C_IMP, C_BAL)
        ax4 = fig.add_subplot(gs[2, 1])
        self._plot_correlation(ax4, df)
        ax5 = fig.add_subplot(gs[2, 2])
        self._plot_partners(ax5)

        # 4. Volatilidade e Scatter
        ax6 = fig.add_subplot(gs[3, 0])
        self._plot_volatility(ax6, df, C_EXP, C_IMP)
        ax7 = fig.add_subplot(gs[3, 1])
        self._plot_scatter(ax7, df, C_ACC)
        ax8 = fig.add_subplot(gs[3, 2])
        self._plot_distribution(ax8, df, C_BAL, C_ACC)

        # 5. Indicadores Econômicos
        ax9 = fig.add_subplot(gs[4, 0])
        self._plot_economic_indicators(ax9, df, C_GDP, C_INF)
        ax10 = fig.add_subplot(gs[4, 1])
        self._plot_moving_averages(ax10, df, C_EXP, C_IMP)
        ax11 = fig.add_subplot(gs[4, 2])
        self._plot_coverage_ratio(ax11, df, C_ACC)

        # 6. Análise de Clustering
        ax12 = fig.add_subplot(gs[5, 0])
        self._plot_clustering(ax12, df, C_EXP, C_IMP, C_BAL)
        ax13 = fig.add_subplot(gs[5, 1])
        self._plot_heatmap(ax13, df)
        ax14 = fig.add_subplot(gs[5, 2])
        self._plot_boxplot(ax14, df, C_EXP, C_IMP, C_BAL)

        # 7. KPIs
        ax15 = fig.add_subplot(gs[6, :])
        self._plot_kpis(ax15, df, C_EXP, C_IMP, C_BAL, C_ACC)

        fig.suptitle('DASHBOARD - ECONOMIA DE TAIWAN', 
                     fontsize=24, fontweight='bold', color='white', y=0.98)
        plt.tight_layout(rect=[0, 0, 1, 0.96])
        plt.savefig(save_path, dpi=150, bbox_inches='tight', 
                   facecolor='#0a0e27', edgecolor='none')
        plt.close()

        logger.info(f"Dashboard salvo: {save_path}")
        return save_path

    def _plot_timeseries(self, ax, df, c_exp, c_imp, c_bal, c_acc):
        """Plota série temporal principal"""
        ax.fill_between(df['date'], 0, df['exports'], alpha=0.12, color=c_exp)
        ax.fill_between(df['date'], 0, df['imports'], alpha=0.12, color=c_imp)
        ax.plot(df['date'], df['exports'], color=c_exp, linewidth=2.5, 
               label='Exportacoes', marker='o', markersize=2.5, markevery=6)
        ax.plot(df['date'], df['imports'], color=c_imp, linewidth=2.5, 
               label='Importacoes', marker='s', markersize=2.5, markevery=6)
        ax.plot(df['date'], df['balance'], color=c_bal, linewidth=2.5, 
               label='Saldo', marker='^', markersize=2.5, markevery=6)

        # Eventos importantes
        events = {
            '2020-03': 'COVID-19',
            '2021-06': 'Boom Chips',
            '2022-02': 'Guerra Ucrania',
            '2023-01': 'Desaceleracao',
            '2024-01': 'Recuperacao AI',
            '2025-01': 'Nova Era AI'
        }

        for date_str, event in events.items():
            date_obj = pd.to_datetime(date_str)
            if df['date'].min() <= date_obj <= df['date'].max():
                ax.axvline(x=date_obj, color=c_acc, linestyle='--', alpha=0.5, linewidth=1.2)
                ax.annotate(event, xy=(date_obj, df['exports'].max()*0.93), 
                           fontsize=8, color=c_acc, rotation=90, ha='right')

        ax.set_title('SERIE TEMPORAL - COMERCIO EXTERIOR', fontsize=15, 
                    fontweight='bold', pad=18, color='white')
        ax.set_ylabel('Milhoes USD', fontsize=11, color='#a0aec0')
        ax.legend(loc='upper left', fontsize=10, framealpha=0.8, 
                 facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.xaxis.set_major_locator(mdates.YearLocator())
        ax.tick_params(colors='#a0aec0')

    def _plot_yoy(self, ax, df, col, title, c_pos, c_neg):
        """Plota gráfico YoY"""
        if col not in df.columns:
            ax.text(0.5, 0.5, 'Dados nao disponiveis', ha='center', va='center',
                   transform=ax.transAxes, color='white', fontsize=12)
            return

        data = df.dropna(subset=[col])
        colors = [c_pos if x >= 0 else c_neg for x in data[col]]
        ax.bar(data['date'], data[col], color=colors, alpha=0.7, width=25)
        ax.axhline(y=0, color='white', linewidth=0.8)
        ax.set_title(title, fontsize=12, fontweight='bold', color='white')
        ax.set_ylabel('%', fontsize=9, color='#a0aec0')
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.xaxis.set_major_locator(mdates.YearLocator(2))
        ax.tick_params(colors='#a0aec0')

    def _plot_seasonality(self, ax, df, c_exp, c_imp, c_bal):
        """Plota sazonalidade"""
        numeric_cols = ['exports', 'imports', 'balance']
        available_cols = [c for c in numeric_cols if c in df.columns]

        if not available_cols:
            return

        monthly = df.groupby('month')[available_cols].mean()
        x = np.arange(1, 13)
        w = 0.25

        if 'exports' in available_cols:
            ax.bar(x - w, monthly['exports'], w, label='Exportacoes', color=c_exp, alpha=0.8)
        if 'imports' in available_cols:
            ax.bar(x, monthly['imports'], w, label='Importacoes', color=c_imp, alpha=0.8)
        if 'balance' in available_cols:
            ax.bar(x + w, monthly['balance'], w, label='Saldo', color=c_bal, alpha=0.8)

        ax.set_title('SAZONALIDADE MENSAL', fontsize=12, fontweight='bold', color='white')
        ax.set_xlabel('Mes', fontsize=9, color='#a0aec0')
        ax.set_ylabel('M USD', fontsize=9, color='#a0aec0')
        ax.set_xticks(x)
        ax.set_xticklabels(['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'])
        ax.legend(fontsize=8, facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.tick_params(colors='#a0aec0')

    def _plot_correlation(self, ax, df):
        """Plota matriz de correlação"""
        numeric_cols = ['exports', 'imports', 'balance', 'gdp_growth', 
                       'inflation', 'unemployment']
        available_cols = [c for c in numeric_cols if c in df.columns]

        if len(available_cols) < 2:
            ax.text(0.5, 0.5, 'Dados insuficientes', ha='center', va='center',
                   transform=ax.transAxes, color='white', fontsize=12)
            return

        corr = df[available_cols].corr()
        im = ax.imshow(corr.values, cmap='RdYlGn', vmin=-1, vmax=1, aspect='auto')

        labels = [c.replace('_', ' ').title() for c in available_cols]
        ax.set_xticks(range(len(available_cols)))
        ax.set_yticks(range(len(available_cols)))
        ax.set_xticklabels(labels, fontsize=8, rotation=45, ha='right')
        ax.set_yticklabels(labels, fontsize=8)

        for i in range(len(available_cols)):
            for j in range(len(available_cols)):
                color = "black" if abs(corr.values[i,j]) < 0.5 else "white"
                ax.text(j, i, f'{corr.values[i,j]:.2f}', ha="center", va="center", 
                       color=color, fontsize=10, fontweight='bold')

        ax.set_title('MATRIZ DE CORRELACAO', fontsize=12, fontweight='bold', color='white')
        plt.colorbar(im, ax=ax, shrink=0.75, label='Correlacao')

    def _plot_partners(self, ax):
        """Plota parceiros comerciais"""
        partners = ['China', 'USA', 'ASEAN', 'Japan', 'S.Korea', 'EU', 'Outros']
        values = [85000, 45000, 54000, 36000, 24000, 36000, 18000]
        colors = ['#ff6b6b', '#4dabf7', '#00d4aa', '#ffd43b', '#da77f2', '#ff922b', '#868e96']

        wedges, texts, autotexts = ax.pie(values, labels=partners, autopct='%1.1f%%',
                                          colors=colors, startangle=90, 
                                          textprops={'fontsize': 8, 'color': 'white'})
        for autotext in autotexts:
            autotext.set_color('white')
            autotext.set_fontweight('bold')
        ax.set_title('PARCEIROS COMERCIAIS', fontsize=12, fontweight='bold', color='white')

    def _plot_volatility(self, ax, df, c_exp, c_imp):
        """Plota volatilidade"""
        vol_cols = ['exports_vol', 'imports_vol']

        for col, color in zip(vol_cols, [c_exp, c_imp]):
            if col in df.columns:
                vol_data = df.dropna(subset=[col])
                ax.fill_between(vol_data['date'], 0, vol_data[col], alpha=0.25, color=color)
                ax.plot(vol_data['date'], vol_data[col], color=color, linewidth=2, 
                       label=col.replace('_', ' ').title())

        ax.set_title('VOLATILIDADE (12M)', fontsize=12, fontweight='bold', color='white')
        ax.set_ylabel('M USD', fontsize=9, color='#a0aec0')
        ax.legend(fontsize=8, facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.tick_params(colors='#a0aec0')

    def _plot_scatter(self, ax, df, c_acc):
        """Plota scatter plot"""
        if 'imports' not in df.columns or 'exports' not in df.columns:
            return

        scatter = ax.scatter(df['imports'], df['exports'], c=df['year'], 
                            cmap='viridis', alpha=0.7, s=50, 
                            edgecolors='white', linewidth=0.5)

        z = np.polyfit(df['imports'], df['exports'], 1)
        p = np.poly1d(z)
        ax.plot(df['imports'], p(df['imports']), color=c_acc, linewidth=2, 
               linestyle='--', label='Tendencia')

        ax.set_title('EXPORTACOES vs IMPORTACOES', fontsize=12, fontweight='bold', color='white')
        ax.set_xlabel('Importacoes (M USD)', fontsize=9, color='#a0aec0')
        ax.set_ylabel('Exportacoes (M USD)', fontsize=9, color='#a0aec0')
        ax.legend(fontsize=8, facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.tick_params(colors='#a0aec0')
        plt.colorbar(scatter, ax=ax, shrink=0.75, label='Ano')

    def _plot_distribution(self, ax, df, c_bal, c_acc):
        """Plota distribuição do saldo"""
        if 'balance' not in df.columns:
            return

        ax.hist(df['balance'], bins=30, color=c_bal, alpha=0.7, 
               edgecolor='white', linewidth=1)
        ax.axvline(df['balance'].mean(), color=c_acc, linewidth=2, 
                  linestyle='--', label=f'Media: ${df["balance"].mean():.0f}M')
        ax.axvline(df['balance'].median(), color='white', linewidth=2, 
                  linestyle=':', label=f'Mediana: ${df["balance"].median():.0f}M')
        ax.set_title('DISTRIBUICAO DO SALDO', fontsize=12, fontweight='bold', color='white')
        ax.set_xlabel('Saldo (M USD)', fontsize=9, color='#a0aec0')
        ax.set_ylabel('Frequencia', fontsize=9, color='#a0aec0')
        ax.legend(fontsize=8, facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.tick_params(colors='#a0aec0')

    def _plot_economic_indicators(self, ax, df, c_gdp, c_inf):
        """Plota indicadores econômicos"""
        indicators = ['gdp_growth', 'inflation', 'unemployment']
        colors = [c_gdp, '#ff922b', '#da77f2']

        for col, color in zip(indicators, colors):
            if col in df.columns:
                ax.plot(df['date'], df[col], color=color, linewidth=2, 
                       label=col.replace('_', ' ').title(), alpha=0.8)

        ax.set_title('INDICADORES ECONOMICOS', fontsize=12, fontweight='bold', color='white')
        ax.set_ylabel('%', fontsize=9, color='#a0aec0')
        ax.legend(fontsize=8, facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.tick_params(colors='#a0aec0')
        ax.axhline(y=0, color='white', linewidth=0.5, alpha=0.5)

    def _plot_moving_averages(self, ax, df, c_exp, c_imp):
        """Plota médias móveis"""
        if 'exports_ma3' in df.columns:
            ax.plot(df['date'], df['exports_ma3'], color=c_exp, linewidth=1.5, 
                   label='Exp MA3', alpha=0.7, linestyle='--')
        if 'exports_ma12' in df.columns:
            ax.plot(df['date'], df['exports_ma12'], color=c_exp, linewidth=2.5, 
                   label='Exp MA12', alpha=0.9)
        if 'imports_ma3' in df.columns:
            ax.plot(df['date'], df['imports_ma3'], color=c_imp, linewidth=1.5, 
                   label='Imp MA3', alpha=0.7, linestyle='--')
        if 'imports_ma12' in df.columns:
            ax.plot(df['date'], df['imports_ma12'], color=c_imp, linewidth=2.5, 
                   label='Imp MA12', alpha=0.9)

        ax.set_title('MEDIAS MOVEIS', fontsize=12, fontweight='bold', color='white')
        ax.set_ylabel('M USD', fontsize=9, color='#a0aec0')
        ax.legend(fontsize=8, facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.tick_params(colors='#a0aec0')

    def _plot_coverage_ratio(self, ax, df, c_acc):
        """Plota razão de cobertura"""
        if 'coverage_ratio' not in df.columns:
            return

        ax.plot(df['date'], df['coverage_ratio'], color=c_acc, linewidth=2.5)
        ax.axhline(y=100, color='white', linewidth=1, linestyle='--', alpha=0.5, 
                  label='Equilibrio (100%)')
        ax.fill_between(df['date'], 100, df['coverage_ratio'], 
                       where=df['coverage_ratio'] >= 100, alpha=0.2, color='#00d4aa')
        ax.fill_between(df['date'], 100, df['coverage_ratio'], 
                       where=df['coverage_ratio'] < 100, alpha=0.2, color='#ff6b6b')

        ax.set_title('RAZAO DE COBERTURA', fontsize=12, fontweight='bold', color='white')
        ax.set_ylabel('%', fontsize=9, color='#a0aec0')
        ax.legend(fontsize=8, facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        ax.tick_params(colors='#a0aec0')

    def _plot_clustering(self, ax, df, c_exp, c_imp, c_bal):
        """Plota análise de clustering"""
        if 'cluster' not in df.columns or 'exports' not in df.columns or 'imports' not in df.columns:
            ax.text(0.5, 0.5, 'Clustering nao disponivel', ha='center', va='center',
                   transform=ax.transAxes, color='white', fontsize=12)
            return

        clusters = df['cluster'].unique()
        colors = plt.cm.Set1(np.linspace(0, 1, len(clusters)))

        for i, cluster in enumerate(clusters):
            cluster_data = df[df['cluster'] == cluster]
            ax.scatter(cluster_data['imports'], cluster_data['exports'], 
                      c=[colors[i]], label=f'Cluster {int(cluster)}', s=50, alpha=0.7)

        ax.set_title('CLUSTERING (Exp vs Imp)', fontsize=12, fontweight='bold', color='white')
        ax.set_xlabel('Importacoes', fontsize=9, color='#a0aec0')
        ax.set_ylabel('Exportacoes', fontsize=9, color='#a0aec0')
        ax.legend(fontsize=8, facecolor='#0f1535', edgecolor='#2a3f5f')
        ax.tick_params(colors='#a0aec0')

    def _plot_heatmap(self, ax, df):
        """Plota heatmap de correlação temporal"""
        numeric_cols = ['exports', 'imports', 'balance']
        available = [c for c in numeric_cols if c in df.columns]

        if not available:
            return

        # Correlacao rolling de 12 meses
        df_copy = df.copy()
        df_copy['year_month'] = df_copy['date'].dt.to_period('M')

        # Simplificar: heatmap anual
        yearly = df_copy.groupby('year')[available].mean()
        im = ax.imshow(yearly.T.values, cmap='RdYlGn', aspect='auto', 
                      vmin=yearly.min().min(), vmax=yearly.max().max())

        ax.set_xticks(range(len(yearly.index)))
        ax.set_xticklabels(yearly.index, fontsize=8)
        ax.set_yticks(range(len(available)))
        ax.set_yticklabels([c.title() for c in available], fontsize=8)
        ax.set_title('HEATMAP ANUAL', fontsize=12, fontweight='bold', color='white')
        plt.colorbar(im, ax=ax, shrink=0.75)
        ax.tick_params(colors='#a0aec0')

    def _plot_boxplot(self, ax, df, c_exp, c_imp, c_bal):
        """Plota boxplot por ano"""
        numeric_cols = ['exports', 'imports', 'balance']
        available = [c for c in numeric_cols if c in df.columns]

        if not available:
            return

        data_to_plot = [df[col].dropna().values for col in available]
        bp = ax.boxplot(data_to_plot, labels=[c.title() for c in available], 
                       patch_artist=True)

        colors = [c_exp, c_imp, c_bal]
        for patch, color in zip(bp['boxes'], colors[:len(available)]):
            patch.set_facecolor(color)
            patch.set_alpha(0.7)

        ax.set_title('DISTRIBUICAO POR INDICADOR', fontsize=12, fontweight='bold', color='white')
        ax.set_ylabel('M USD', fontsize=9, color='#a0aec0')
        ax.tick_params(colors='#a0aec0')

    def _plot_kpis(self, ax, df, c_exp, c_imp, c_bal, c_acc):
        """Plota KPIs principais"""
        ax.axis('off')

        latest = df.iloc[-1]
        prev = df.iloc[-13] if len(df) >= 13 else df.iloc[0]

        kpis = [
            ('Exportacoes', f'${latest["exports"]:,.0f}M', 
             f'{((latest["exports"]/prev["exports"]-1)*100):+.1f}% YoY', c_exp),
            ('Importacoes', f'${latest["imports"]:,.0f}M', 
             f'{((latest["imports"]/prev["imports"]-1)*100):+.1f}% YoY', c_imp),
            ('Saldo', f'${latest["balance"]:,.0f}M', 
             f'Media: ${df["balance"].mean():,.0f}M', c_bal),
            ('Media Exp.', f'${df["exports"].mean():,.0f}M', 
             f'Max: ${df["exports"].max():,.0f}M', c_exp),
            ('Media Imp.', f'${df["imports"].mean():,.0f}M', 
             f'Max: ${df["imports"].max():,.0f}M', c_imp),
            ('Cobertura', f'{df["coverage_ratio"].mean():.1f}%', 
             f'Atual: {latest["coverage_ratio"]:.1f}%', c_acc),
        ]

        for i, (title, value, sub, color) in enumerate(kpis):
            x = 0.04 + i * 0.16
            rect = mpatches.FancyBboxPatch((x, 0.12), 0.145, 0.76, 
                                          boxstyle="round,pad=0.015", 
                                          facecolor='#131d35', edgecolor=color, linewidth=2.5)
            ax.add_patch(rect)
            ax.text(x + 0.072, 0.78, title, ha='center', va='center', 
                   fontsize=9, color='#8899aa', fontweight='bold', 
                   transform=ax.transAxes)
            ax.text(x + 0.072, 0.52, value, ha='center', va='center', 
                   fontsize=15, color=color, fontweight='bold', 
                   transform=ax.transAxes)
            ax.text(x + 0.072, 0.28, sub, ha='center', va='center', 
                   fontsize=8, color='#8899aa', transform=ax.transAxes)

        ax.set_xlim(0, 1)
        ax.set_ylim(0, 1)
        ax.set_title('KPIs PRINCIPAIS', fontsize=14, fontweight='bold', 
                    pad=8, y=0.95, color='white')
