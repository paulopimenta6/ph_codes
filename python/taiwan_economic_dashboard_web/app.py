#!/usr/bin/env python3
import os
import sys
import time
import json
import logging
import argparse
import threading
from pathlib import Path
from functools import lru_cache
from datetime import datetime, timedelta

import numpy as np
import pandas as pd
import plotly
import plotly.graph_objects as go
import plotly.express as px
from plotly.subplots import make_subplots
from flask import Flask, render_template, jsonify, request, send_from_directory

from taiwan_trade_production import (
    Config, DataCollector, DataProcessor, MultivariateAnalyzer,
    DatabaseManager, TaiwanTradeAnalyzer
)

app = Flask(__name__)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s | %(levelname)-8s | %(name)s | %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
)
logger = logging.getLogger('WebDashboard')

C_EXP = '#00d4aa'
C_IMP = '#ff6b6b'
C_BAL = '#4dabf7'
C_ACC = '#ffd43b'

_analyzer = None
_df_clean = None
_df_raw = None
_analysis_results = None
_data_loaded = False
_last_data_date = None
_update_interval_seconds = 3600  # 1 hora entre verificacoes
_scheduler_running = False

# URL da API MOEA para verificar se ha dados novos
_MOEA_CHECK_URL = "https://publicinfo.trade.gov.tw/cuswebo/FSCE30C0I/FormAGetData"

events = [
    ('2020-03-01', 'COVID-19', '#ff6b6b'),
    ('2021-06-01', 'Boom Chips', '#00d4aa'),
    ('2022-02-01', 'Guerra Ucrânia', '#ffd43b'),
    ('2023-01-01', 'Desaceleração', '#ff922b'),
    ('2024-01-01', 'Recuperação AI', '#4dabf7'),
]

partners_data = [
    ('China', 85000, 28.5), ('USA', 45000, 15.1),
    ('ASEAN', 54000, 18.1), ('Japan', 36000, 12.1),
    ('S.Korea', 24000, 8.1), ('EU', 36000, 12.1),
    ('Outros', 18000, 6.0),
]

partner_colors = ['#ff6b6b', '#4dabf7', '#00d4aa', '#ffd43b', '#da77f2', '#ff922b', '#868e96']


def load_data(force: bool = False) -> bool:
    global _df_clean, _df_raw, _analysis_results, _data_loaded, _analyzer, _last_data_date
    if _data_loaded and not force:
        return True

    config = Config()
    _analyzer = TaiwanTradeAnalyzer(config)

    try:
        logger.info("Carregando dados...")
        _df_raw = _analyzer.collector.collect(prefer_real=True)
        if _df_raw is None or len(_df_raw) == 0:
            logger.error("Falha na coleta de dados")
            return False

        # Repassar dados MOEA para processor aplicar apos outlier/filter
        moea_df = getattr(_analyzer.collector, '_moea_raw_merge', None)
        if moea_df is not None:
            _analyzer.processor.set_moea_data(moea_df)
        _df_clean = _analyzer.processor.process(_df_raw)
        if _df_clean is None:
            return False

        _analysis_results = _analyzer.analyzer.analyze(_df_clean)
        _data_loaded = True
        _last_data_date = _df_clean['date'].max()
        if hasattr(_last_data_date, 'to_pydatetime'):
            _last_data_date = _last_data_date.to_pydatetime()
        logger.info(f"Dados carregados: {len(_df_clean)} registros")
        return True
    except Exception as e:
        logger.error(f"Erro no carregamento: {e}", exc_info=True)
        return False


def check_moea_for_updates() -> bool:
    """
    Verifica se existem dados mais recentes na API MOEA.
    Retorna True se novos dados foram carregados.
    """
    global _df_clean, _df_raw, _analysis_results, _data_loaded, _last_data_date

    try:
        import requests as req
        resp = req.post(_MOEA_CHECK_URL, data={'IE_CODE': 'out'},
                        timeout=15,
                        headers={'User-Agent': 'Mozilla/5.0'})
        if resp.status_code != 200:
            return False

        data = resp.json()
        dates = data.get('DATA_DAY_LIST_FORMA', [])
        if not dates:
            return False

        latest_api_date = max(dates)
        year = int(latest_api_date[:4])
        month = int(latest_api_date[4:6])
        latest_api_dt = datetime(year, month, 1)

        if _last_data_date is None and _df_clean is not None:
            _last_data_date = _df_clean['date'].max()
            if hasattr(_last_data_date, 'to_pydatetime'):
                _last_data_date = _last_data_date.to_pydatetime()

        if _last_data_date and latest_api_dt <= _last_data_date:
            return False

        logger.info(f"Novos dados MOEA detectados: {latest_api_date} "
                     f"(atual: {_last_data_date.strftime('%Y-%m') if _last_data_date else 'N/A'})")
        return load_data(force=True)

    except Exception as e:
        logger.warning(f"Erro na verificacao MOEA: {e}")
        return False


def scheduler_loop():
    """Loop executado em thread separada para verificar atualizacoes."""
    global _scheduler_running
    _scheduler_running = True
    logger.info(f"Scheduler iniciado (intervalo: {_update_interval_seconds}s)")

    while _scheduler_running:
        time.sleep(_update_interval_seconds)
        try:
            if check_moea_for_updates():
                logger.info("Dashboard atualizado com novos dados MOEA")
        except Exception as e:
            logger.warning(f"Scheduler: erro na verificacao: {e}")


def start_scheduler(interval_seconds: int = 3600):
    """Inicia o scheduler em background."""
    global _update_interval_seconds, _scheduler_running
    _update_interval_seconds = interval_seconds
    if _scheduler_running:
        logger.info("Scheduler ja esta rodando")
        return
    thread = threading.Thread(target=scheduler_loop, daemon=True)
    thread.start()
    logger.info(f"Scheduler de atualizacao iniciado (a cada {interval_seconds}s)")


def get_df() -> pd.DataFrame:
    if not _data_loaded:
        load_data()
    return _df_clean


def get_kpi_data(df: pd.DataFrame) -> dict:
    latest = df.iloc[-1]
    prev = df.iloc[-13] if len(df) >= 13 else df.iloc[0]
    return {
        'exports': {'value': f'${latest["exports"]:,.0f}M', 'change': f'{((latest["exports"]/prev["exports"]-1)*100):+.1f}% YoY'},
        'imports': {'value': f'${latest["imports"]:,.0f}M', 'change': f'{((latest["imports"]/prev["imports"]-1)*100):+.1f}% YoY'},
        'balance': {'value': f'${latest["balance"]:,.0f}M', 'change': f'Média: ${df["balance"].mean():,.0f}M'},
        'avg_exp': {'value': f'${df["exports"].mean():,.0f}M', 'change': f'Max: ${df["exports"].max():,.0f}M'},
        'avg_imp': {'value': f'${df["imports"].mean():,.0f}M', 'change': f'Max: ${df["imports"].max():,.0f}M'},
        'coverage': {'value': f'{df["coverage_ratio"].mean():.1f}%', 'change': f'Atual: {latest["coverage_ratio"]:.1f}%'},
    }


def _dark_layout(title: str = '', **kwargs) -> dict:
    layout = dict(
        paper_bgcolor='#0f1535',
        plot_bgcolor='#0f1535',
        font=dict(color='#e2e8f0', size=10),
        title=dict(text=title, font=dict(size=14, color='#e2e8f0'), x=0.5),
        margin=dict(l=50, r=20, t=50, b=40),
        hovermode='x unified',
        xaxis=dict(gridcolor='#1e293b', zerolinecolor='#2a3f5f', linecolor='#2a3f5f'),
        yaxis=dict(gridcolor='#1e293b', zerolinecolor='#2a3f5f', linecolor='#2a3f5f'),
        legend=dict(bgcolor='rgba(15,21,53,0.8)', bordercolor='#2a3f5f'),
    )
    layout.update(kwargs)
    return layout


def fig_timeseries(df: pd.DataFrame) -> go.Figure:
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=df['date'], y=df['exports'], mode='lines+markers',
        name='Exportações', line=dict(color=C_EXP, width=2.5),
        marker=dict(size=4, color=C_EXP), fill='tozeroy', fillcolor='rgba(0,212,170,0.08)'))
    fig.add_trace(go.Scatter(x=df['date'], y=df['imports'], mode='lines+markers',
        name='Importações', line=dict(color=C_IMP, width=2.5),
        marker=dict(size=4, color=C_IMP), fill='tozeroy', fillcolor='rgba(255,107,107,0.08)'))
    fig.add_trace(go.Scatter(x=df['date'], y=df['balance'], mode='lines+markers',
        name='Saldo', line=dict(color=C_BAL, width=2.5, dash='dot'),
        marker=dict(size=4, color=C_BAL)))

    for date_str, label, color in events:
        d = pd.to_datetime(date_str)
        if df['date'].min() <= d <= df['date'].max():
            fig.add_vline(x=d, line=dict(color=color, width=1.2, dash='dash'))
            fig.add_annotation(x=d, y=df['exports'].max()*0.95,
                text=label, showarrow=False, font=dict(size=9, color=color),
                textangle=90, yshift=5)

    fig.update_layout(**_dark_layout('Série Temporal - Comércio de Taiwan',
        yaxis=dict(title='Milhões USD'), height=400))
    fig.update_xaxes(rangeslider=dict(visible=True, thickness=0.05))
    return fig


def fig_yoy_exports(df: pd.DataFrame) -> go.Figure:
    data = df.dropna(subset=['exports_yoy'])
    colors = [C_EXP if x >= 0 else C_IMP for x in data['exports_yoy']]
    fig = go.Figure()
    fig.add_trace(go.Bar(x=data['date'], y=data['exports_yoy'],
        marker_color=colors, name='YoY', showlegend=False))
    fig.add_hline(y=0, line=dict(color='white', width=0.8))
    fig.update_layout(**_dark_layout('Exportações YoY', yaxis=dict(title='%'),
        height=250, margin=dict(l=40, r=10, t=40, b=30)))
    return fig


def fig_yoy_imports(df: pd.DataFrame) -> go.Figure:
    data = df.dropna(subset=['imports_yoy'])
    colors = [C_EXP if x >= 0 else C_IMP for x in data['imports_yoy']]
    fig = go.Figure()
    fig.add_trace(go.Bar(x=data['date'], y=data['imports_yoy'],
        marker_color=colors, name='YoY', showlegend=False))
    fig.add_hline(y=0, line=dict(color='white', width=0.8))
    fig.update_layout(**_dark_layout('Importações YoY', yaxis=dict(title='%'),
        height=250, margin=dict(l=40, r=10, t=40, b=30)))
    return fig


def fig_yoy_balance(df: pd.DataFrame) -> go.Figure:
    data = df.dropna(subset=['balance_yoy'])
    colors = [C_EXP if x >= 0 else C_IMP for x in data['balance_yoy']]
    fig = go.Figure()
    fig.add_trace(go.Bar(x=data['date'], y=data['balance_yoy'],
        marker_color=colors, name='YoY', showlegend=False))
    fig.add_hline(y=0, line=dict(color='white', width=0.8))
    fig.update_layout(**_dark_layout('Saldo YoY', yaxis=dict(title='%'),
        height=250, margin=dict(l=40, r=10, t=40, b=30)))
    return fig


def fig_seasonality(df: pd.DataFrame) -> go.Figure:
    monthly = df.groupby('month')[['exports', 'imports', 'balance']].mean()
    x = list(range(1, 13))
    labels = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']
    fig = go.Figure()
    fig.add_trace(go.Bar(x=x, y=monthly['exports'], name='Exportações',
        marker_color=C_EXP, offset=-0.25, width=0.25))
    fig.add_trace(go.Bar(x=x, y=monthly['imports'], name='Importações',
        marker_color=C_IMP, width=0.25))
    fig.add_trace(go.Bar(x=x, y=monthly['balance'], name='Saldo',
        marker_color=C_BAL, offset=0.25, width=0.25))
    fig.update_layout(**_dark_layout('Sazonalidade Mensal',
        xaxis=dict(tickmode='array', tickvals=x, ticktext=labels, title='Mês'),
        yaxis=dict(title='Média (M USD)'),
        height=300, barmode='group', margin=dict(l=40, r=10, t=40, b=30)))
    return fig


def fig_correlation(df: pd.DataFrame) -> go.Figure:
    corr = df[['exports', 'imports', 'balance']].corr()
    labels = ['Exportações', 'Importações', 'Saldo']
    fig = go.Figure(data=go.Heatmap(
        z=corr.values, x=labels, y=labels,
        colorscale='RdYlGn', zmin=-1, zmax=1,
        text=[[f'{v:.3f}' for v in row] for row in corr.values],
        texttemplate='%{text}',
        textfont=dict(size=13, color='white'),
        hovertemplate='%{x} vs %{y}<br>Correlação: %{z:.4f}<extra></extra>'))
    fig.update_layout(**_dark_layout('Matriz de Correlação',
        height=300, margin=dict(l=40, r=10, t=40, b=30)))
    return fig


def fig_partners() -> go.Figure:
    labels = [p[0] for p in partners_data]
    values = [p[1] for p in partners_data]
    fig = go.Figure(data=[go.Pie(labels=labels, values=values,
        marker=dict(colors=partner_colors),
        textinfo='label+percent', textfont=dict(size=11, color='white'),
        hovertemplate='%{label}<br>%{value:,.0f}M USD (%{percent})<extra></extra>')])
    fig.update_layout(**_dark_layout('Principais Parceiros Comerciais',
        height=300, margin=dict(l=20, r=20, t=40, b=20),
        showlegend=False))
    return fig


def fig_volatility(df: pd.DataFrame) -> go.Figure:
    vol = df.dropna(subset=['exports_vol'])
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=vol['date'], y=vol['exports_vol'],
        mode='lines', name='Vol. Exportações',
        line=dict(color=C_EXP, width=2),
        fill='tozeroy', fillcolor='rgba(0,212,170,0.15)'))
    fig.add_trace(go.Scatter(x=vol['date'], y=vol['imports_vol'],
        mode='lines', name='Vol. Importações',
        line=dict(color=C_IMP, width=2),
        fill='tozeroy', fillcolor='rgba(255,107,107,0.15)'))
    fig.update_layout(**_dark_layout('Volatilidade (12m)',
        yaxis=dict(title='M USD'), height=300,
        margin=dict(l=40, r=10, t=40, b=30)))
    return fig


def fig_scatter(df: pd.DataFrame) -> go.Figure:
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=df['imports'], y=df['exports'],
        mode='markers',
        marker=dict(size=8, color=df['year'], colorscale='Viridis',
                    showscale=True, colorbar=dict(title='Ano', x=1.02),
                    line=dict(width=0.5, color='white')),
        hovertemplate='Imp: %{x:,.0f}M<br>Exp: %{y:,.0f}M<extra></extra>',
        name='Observações'))

    z = np.polyfit(df['imports'].values, df['exports'].values, 1)
    p = np.poly1d(z)
    x_line = np.linspace(df['imports'].min(), df['imports'].max(), 100)
    fig.add_trace(go.Scatter(x=x_line, y=p(x_line),
        mode='lines', name='Tendência',
        line=dict(color=C_ACC, width=2, dash='dash')))

    fig.update_layout(**_dark_layout('Exportações vs Importações',
        xaxis=dict(title='Importações (M USD)'),
        yaxis=dict(title='Exportações (M USD)'),
        height=300, margin=dict(l=40, r=50, t=40, b=30)))
    return fig


def fig_distribution(df: pd.DataFrame) -> go.Figure:
    fig = go.Figure()
    fig.add_trace(go.Histogram(x=df['balance'], nbinsx=30,
        marker_color=C_BAL, opacity=0.7,
        marker_line=dict(color='white', width=1),
        hovertemplate='Saldo: %{x:,.0f}M<br>Freq: %{y}<extra></extra>',
        name='Distribuição'))

    mean_val = df['balance'].mean()
    median_val = df['balance'].median()
    fig.add_vline(x=mean_val, line=dict(color=C_ACC, width=2, dash='dash'),
        annotation_text=f'Média: ${mean_val:,.0f}M')
    fig.add_vline(x=median_val, line=dict(color='white', width=2, dash='dot'),
        annotation_text=f'Mediana: ${median_val:,.0f}M')

    fig.update_layout(**_dark_layout('Distribuição do Saldo Comercial',
        xaxis=dict(title='Saldo (M USD)'),
        yaxis=dict(title='Frequência'),
        height=300, margin=dict(l=40, r=10, t=40, b=30),
        bargap=0.05))
    return fig


@app.route('/')
def index():
    if not _data_loaded and not load_data():
        return render_template('dashboard.html', error='Falha ao carregar dados'), 500
    df = get_df()
    if df is None:
        return render_template('dashboard.html', error='Sem dados disponíveis'), 500
    kpi = get_kpi_data(df)
    return render_template('dashboard.html', kpi=kpi,
        source=','.join(_analyzer.collector.data_sources) if _analyzer else 'N/A',
        records=len(df), last_update=df['date'].max().strftime('%Y-%m-%d'))


@app.route('/api/data')
def api_data():
    df = get_df()
    if df is None:
        return jsonify({'error': 'No data'}), 500
    return jsonify({
        'dates': df['date'].dt.strftime('%Y-%m-%d').tolist(),
        'exports': df['exports'].round(2).tolist(),
        'imports': df['imports'].round(2).tolist(),
        'balance': df['balance'].round(2).tolist(),
        'exports_yoy': df['exports_yoy'].round(2).tolist(),
        'imports_yoy': df['imports_yoy'].round(2).tolist(),
        'balance_yoy': df['balance_yoy'].round(2).tolist(),
        'exports_vol': [None if pd.isna(x) else round(x, 2) for x in df['exports_vol']],
        'imports_vol': [None if pd.isna(x) else round(x, 2) for x in df['imports_vol']],
        'coverage_ratio': df['coverage_ratio'].round(2).tolist(),
        'year': df['year'].tolist(),
    })


@app.route('/api/figures')
def api_figures():
    df = get_df()
    if df is None:
        return jsonify({'error': 'No data'}), 500

    figures = {
        'timeseries': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_timeseries(df))),
        'yoy_exports': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_yoy_exports(df))),
        'yoy_imports': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_yoy_imports(df))),
        'yoy_balance': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_yoy_balance(df))),
        'seasonality': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_seasonality(df))),
        'correlation': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_correlation(df))),
        'partners': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_partners())),
        'volatility': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_volatility(df))),
        'scatter': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_scatter(df))),
        'distribution': json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig_distribution(df))),
    }
    return jsonify(figures)


@app.route('/api/reload')
def api_reload():
    if load_data(force=True):
        return jsonify({'status': 'ok', 'records': len(_df_clean)})
    return jsonify({'status': 'error'}), 500


@app.route('/api/check-update')
def api_check_update():
    """Verifica manualmente se existem dados novos na MOEA e atualiza se necessario."""
    logger.info("Verificacao manual de atualizacao...")
    updated = check_moea_for_updates()
    last_date = _df_clean['date'].max().strftime('%Y-%m-%d') if _df_clean is not None else 'N/A'
    return jsonify({
        'updated': updated,
        'records': len(_df_clean) if _df_clean is not None else 0,
        'last_date': last_date,
        'source': ','.join(_analyzer.collector.data_sources) if _analyzer else 'N/A',
    })


@app.route('/api/health')
def api_health():
    last_date = _df_clean['date'].max().strftime('%Y-%m-%d') if _df_clean is not None else 'N/A'
    return jsonify({
        'status': 'ok' if _data_loaded else 'loading',
        'records': len(_df_clean) if _df_clean is not None else 0,
        'source': ','.join(_analyzer.collector.data_sources) if _analyzer else 'N/A',
        'last_update': last_date,
        'scheduler_running': _scheduler_running,
        'check_interval_seconds': _update_interval_seconds,
    })


@app.route('/static/<path:path>')
def static_files(path):
    return send_from_directory('static', path)


def create_standalone_html(output_path: str = 'dashboard_interativo.html'):
    """Gera um arquivo HTML standalone com todos os gráficos embutidos."""
    if not _data_loaded and not load_data():
        logger.error("Não foi possível carregar dados para o HTML standalone")
        return

    df = get_df()
    if df is None:
        return

    figures = {
        'timeseries': fig_timeseries(df),
        'yoy_exports': fig_yoy_exports(df),
        'yoy_imports': fig_yoy_imports(df),
        'yoy_balance': fig_yoy_balance(df),
        'seasonality': fig_seasonality(df),
        'correlation': fig_correlation(df),
        'partners': fig_partners(),
        'volatility': fig_volatility(df),
        'scatter': fig_scatter(df),
        'distribution': fig_distribution(df),
    }

    kpi = get_kpi_data(df)
    source = ','.join(_analyzer.collector.data_sources) if _analyzer else 'N/A'

    fig_json = {}
    for name, fig in figures.items():
        fig_json[name] = json.loads(plotly.utils.PlotlyJSONEncoder().encode(fig))

    import jinja2
    template_loader = jinja2.FileSystemLoader(searchpath=os.path.join(os.path.dirname(__file__), 'templates'))
    template_env = jinja2.Environment(loader=template_loader)
    template = template_env.get_template('dashboard.html')

    html = template.render(
        kpi=kpi,
        source=source,
        records=len(df),
        last_update=df['date'].max().strftime('%Y-%m-%d'),
        standalone=True,
        figures_json=json.dumps(fig_json),
    )

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)
    logger.info(f"HTML standalone gerado: {output_path}")


def main():
    parser = argparse.ArgumentParser(description='Taiwan Dashboard Web - Interativo')
    parser.add_argument('--host', default='0.0.0.0', help='Host (default: 0.0.0.0)')
    parser.add_argument('--port', type=int, default=5000, help='Porta (default: 5000)')
    parser.add_argument('--debug', action='store_true', help='Modo debug')
    parser.add_argument('--no-web', action='store_true',
        help='Apenas gerar HTML standalone (sem servidor web)')
    parser.add_argument('--output', default='dashboard_interativo.html',
        help='Arquivo de saida para HTML standalone')
    parser.add_argument('--reload', action='store_true',
        help='Forcar recarga dos dados na inicializacao')
    parser.add_argument('--pi-mode', action='store_true',
        help='Modo Raspberry Pi (otimizacoes de memoria)')
    parser.add_argument('--update-interval', type=int, default=3600,
        help='Intervalo em segundos entre verificacoes de novos dados MOEA (default: 3600)')
    parser.add_argument('--no-scheduler', action='store_true',
        help='Desabilitar verificacao automatica de atualizacoes')

    args = parser.parse_args()

    if args.pi_mode:
        logger.info("Modo Raspberry Pi ativado - otimizacoes de memoria")
        os.environ['OMP_NUM_THREADS'] = '2'
        os.environ['MKL_NUM_THREADS'] = '2'
        os.environ['OPENBLAS_NUM_THREADS'] = '2'
        import matplotlib
        matplotlib.use('Agg')

    logger.info("Carregando dados...")
    if not load_data(force=args.reload):
        logger.error("Falha ao carregar dados. Verifique a conexao com a internet.")
        sys.exit(1)

    if args.no_web:
        logger.info("Gerando HTML standalone...")
        create_standalone_html(args.output)
        logger.info(f"Arquivo gerado: {args.output}")
        return

    if not args.no_scheduler:
        start_scheduler(interval_seconds=args.update_interval)

    logger.info(f"Iniciando servidor em http://{args.host}:{args.port}")
    logger.info("Pressione Ctrl+C para parar")
    app.run(host=args.host, port=args.port, debug=args.debug, threaded=True)


if __name__ == '__main__':
    main()
