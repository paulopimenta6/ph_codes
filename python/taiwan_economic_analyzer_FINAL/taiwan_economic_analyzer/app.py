"""
Dashboard Interativo Streamlit para Taiwan Economic Analyzer
COM ATUALIZACAO AUTOMATICA EM TEMPO REAL

Quando o daemon (main.py --mode continuous) coleta novos dados,
o dashboard detecta a mudanca no banco e recarrega automaticamente.
"""
import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime
import os
import time

from config import CONFIG
from database import DatabaseManager

# =============================================================================
# CONFIGURACAO DA PAGINA (deve ser a primeira chamada Streamlit)
# =============================================================================
st.set_page_config(
    page_title="Taiwan Economic Analyzer",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded"
)

# =============================================================================
# CONFIGURACAO DE AUTO-REFRESH
# =============================================================================
AUTO_REFRESH_INTERVAL = 60  # segundos

if "refresh_count" not in st.session_state:
    st.session_state.refresh_count = 0
    st.session_state.last_auto_refresh = time.time()

try:
    from streamlit_autorefresh import st_autorefresh
    refresh_count = st_autorefresh(interval=AUTO_REFRESH_INTERVAL * 1000, key="auto_refresh")
except ImportError:
    refresh_count = st.session_state.refresh_count
    if time.time() - st.session_state.last_auto_refresh >= AUTO_REFRESH_INTERVAL:
        st.session_state.refresh_count += 1
        st.session_state.last_auto_refresh = time.time()
        st.cache_data.clear()
        st.rerun()

# CSS customizado
st.markdown("""
<style>
    .main-header {
        font-size: 2.5rem;
        font-weight: bold;
        color: #00d4aa;
        text-align: center;
        margin-bottom: 1rem;
    }
    .sub-header {
        font-size: 1.2rem;
        color: #a0aec0;
        text-align: center;
        margin-bottom: 2rem;
    }
    .status-badge {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 1rem;
        font-size: 0.85rem;
        font-weight: bold;
    }
    .status-online {
        background-color: #00d4aa;
        color: #0a0e27;
    }
    .status-offline {
        background-color: #ff6b6b;
        color: white;
    }
    .status-warning {
        background-color: #ffd43b;
        color: #0a0e27;
    }
    .update-banner {
        background: linear-gradient(90deg, #00d4aa, #4dabf7);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 0.5rem;
        text-align: center;
        font-weight: bold;
        margin-bottom: 1rem;
        animation: pulse 2s infinite;
    }
    @keyframes pulse {
        0% { opacity: 1; }
        50% { opacity: 0.7; }
        100% { opacity: 1; }
    }
</style>
""", unsafe_allow_html=True)


# =============================================================================
# FUNCOES DE CARREGAMENTO DE DADOS (COM CACHE CURTO)
# =============================================================================

@st.cache_data(ttl=30)
def load_data():
    """Carrega dados do banco SQLite com cache de 30s para atualizacao em tempo real"""
    db = DatabaseManager()
    try:
        with db:
            return db.get_all_data()
    except Exception as e:
        st.error(f"Erro ao carregar dados: {e}")
        return None


@st.cache_data(ttl=30)
def load_moea_data():
    """Carrega dados MOEA do banco"""
    db = DatabaseManager()
    try:
        with db:
            return db.get_moea_data()
    except Exception:
        return None


@st.cache_data(ttl=60)
def load_alerts():
    """Carrega alertas ativos"""
    db = DatabaseManager()
    try:
        with db:
            return db.get_active_alerts()
    except Exception:
        return pd.DataFrame()


@st.cache_data(ttl=30)
def load_execution_history(limit=5):
    """Carrega historico de execucoes"""
    db = DatabaseManager()
    try:
        with db:
            return db.get_execution_history(limit)
    except Exception:
        return pd.DataFrame()


# =============================================================================
# RENDERIZACAO DOS COMPONENTES
# =============================================================================

def render_header():
    """Renderiza cabecalho com status de producao"""
    if refresh_count > 0:
        st.markdown(f'''
            <div class="update-banner">
                🔄 Dashboard atualizado automaticamente | Refresh #{refresh_count} |
                {datetime.now().strftime("%H:%M:%S")}
            </div>
        ''', unsafe_allow_html=True)
    
    col1, col2, col3 = st.columns([3, 1, 1])
    
    with col1:
        st.markdown('<div class="main-header">📊 Taiwan Economic Analyzer</div>', unsafe_allow_html=True)
        st.markdown('<div class="sub-header">Dashboard Interativo de Indicadores Economicos</div>', unsafe_allow_html=True)
    
    with col2:
        if os.path.exists(CONFIG.DB_PATH):
            mtime = os.path.getmtime(CONFIG.DB_PATH)
            last_update = datetime.fromtimestamp(mtime)
            minutes_ago = (datetime.now() - last_update).total_seconds() / 60
            
            if minutes_ago < 120:
                status_class = "status-online"
                status_text = "ONLINE"
            elif minutes_ago < 360:
                status_class = "status-warning"
                status_text = "ATRASADO"
            else:
                status_class = "status-offline"
                status_text = "OFFLINE"
            
            st.markdown(f'<div class="status-badge {status_class}">{status_text}</div>', unsafe_allow_html=True)
            st.caption(f"Ultima atualizacao: {last_update.strftime('%H:%M')}")
    
    with col3:
        alerts = load_alerts()
        if len(alerts) > 0:
            st.markdown(f'<div class="status-badge status-offline">⚠️ {len(alerts)} ALERTAS</div>', unsafe_allow_html=True)
        else:
            st.markdown('<div class="status-badge status-online">✅ OK</div>', unsafe_allow_html=True)
    
    st.markdown("---")


def render_kpis(df):
    """Renderiza KPIs principais"""
    if df is None or len(df) == 0:
        st.warning("Nenhum dado disponivel")
        return
    
    latest = df.iloc[-1]
    prev = df.iloc[-13] if len(df) >= 13 else df.iloc[0]
    
    col1, col2, col3, col4, col5, col6 = st.columns(6)
    
    with col1:
        exp_yoy = ((latest["exports"] / prev["exports"] - 1) * 100) if prev["exports"] != 0 else 0
        st.metric(label="Exportacoes", value=f"${latest['exports']:,.0f}M",
                 delta=f"{exp_yoy:+.1f}% YoY")
    
    with col2:
        imp_yoy = ((latest["imports"] / prev["imports"] - 1) * 100) if prev["imports"] != 0 else 0
        st.metric(label="Importacoes", value=f"${latest['imports']:,.0f}M",
                 delta=f"{imp_yoy:+.1f}% YoY")
    
    with col3:
        st.metric(label="Saldo Comercial", value=f"${latest['balance']:,.0f}M",
                 delta=f"Media: ${df['balance'].mean():,.0f}M")
    
    with col4:
        coverage = latest.get("coverage_ratio")
        if coverage is not None and pd.notna(coverage):
            avg_coverage = df["coverage_ratio"].mean() if "coverage_ratio" in df.columns else 0
            st.metric(label="Cobertura", value=f"{coverage:.1f}%",
                     delta=f"Media: {avg_coverage:.1f}%")
        else:
            st.metric(label="Cobertura", value="N/A")
    
    with col5:
        if "gdp_growth" in df.columns:
            gdp = latest.get("gdp_growth", 0)
            st.metric(label="PIB Growth", value=f"{gdp:.2f}%", delta="Anual")
        else:
            st.metric(label="PIB Growth", value="N/A")
    
    with col6:
        if "inflation" in df.columns:
            inf = latest.get("inflation", 0)
            st.metric(label="Inflacao", value=f"{inf:.2f}%", delta="CPI")
        else:
            st.metric(label="Inflacao", value="N/A")


def render_timeseries(df):
    """Renderiza serie temporal"""
    st.subheader("Serie Temporal - Comercio Exterior")
    
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=df["date"], y=df["exports"], mode="lines+markers",
                            name="Exportacoes", line=dict(color="#00d4aa", width=2), marker=dict(size=4)))
    fig.add_trace(go.Scatter(x=df["date"], y=df["imports"], mode="lines+markers",
                            name="Importacoes", line=dict(color="#ff6b6b", width=2), marker=dict(size=4)))
    fig.add_trace(go.Scatter(x=df["date"], y=df["balance"], mode="lines+markers",
                            name="Saldo", line=dict(color="#4dabf7", width=2), marker=dict(size=4)))
    
    events = {
        "2020-03-01": "COVID-19", "2021-06-01": "Boom Chips",
        "2022-02-01": "Guerra Ucrania", "2023-01-01": "Desaceleracao",
        "2024-01-01": "Recuperacao AI", "2025-01-01": "Nova Era AI"
    }
    
    for date_str, event in events.items():
        date_obj = pd.to_datetime(date_str)
        if df["date"].min() <= date_obj <= df["date"].max():
            fig.add_vline(x=date_obj, line_dash="dash", line_color="#ffd43b", opacity=0.5)
            fig.add_annotation(x=date_obj, y=df["exports"].max()*0.95, text=event,
                             showarrow=False, textangle=-90, font=dict(color="#ffd43b", size=10))
    
    fig.update_layout(template="plotly_dark", height=500, xaxis_title="Data", yaxis_title="Milhoes USD",
                     legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1))
    st.plotly_chart(fig, width="stretch")


def render_moea_sector_analysis(df_moea):
    """Renderiza analise de setores MOEA"""
    if df_moea is None or len(df_moea) == 0:
        return
    
    st.subheader("Analise por Setor - MOEA Taiwan")
    
    sector_cols = ["electronic_exports", "machinery_exports", "chemicals_exports",
                   "textiles_exports", "steel_exports", "plastic_exports",
                   "info_tech_exports", "optoelectronic_exports", "semiconductor_exports"]
    available_sectors = [c for c in sector_cols if c in df_moea.columns]
    
    if not available_sectors:
        st.info("Dados de setores MOEA nao disponiveis")
        return
    
    col1, col2 = st.columns(2)
    
    with col1:
        latest = df_moea.iloc[-1]
        sector_values = {s: latest[s] for s in available_sectors if pd.notna(latest[s])}
        
        if sector_values:
            fig = px.treemap(
                names=list(sector_values.keys()),
                parents=["Exportacoes"] * len(sector_values),
                values=list(sector_values.values()),
                color=list(sector_values.values()),
                color_continuous_scale="RdYlGn",
                title="Composicao das Exportacoes por Setor"
            )
            fig.update_layout(template="plotly_dark", height=400)
            st.plotly_chart(fig, width="stretch")
    
    with col2:
        fig = go.Figure()
        colors = px.colors.qualitative.Set1
        for i, col in enumerate(available_sectors[:6]):
            fig.add_trace(go.Scatter(
                x=df_moea["date"], y=df_moea[col],
                mode="lines", name=col.replace("_", " ").title(),
                line=dict(color=colors[i % len(colors)], width=2)
            ))
        fig.update_layout(template="plotly_dark", height=400,
                         title="Evolucao por Setor", xaxis_title="Data", yaxis_title="M USD")
        st.plotly_chart(fig, width="stretch")


def render_yoy_analysis(df):
    """Renderiza analise YoY"""
    st.subheader("Analise Year-over-Year")
    
    col1, col2, col3 = st.columns(3)
    yoy_cols = ["exports_yoy", "imports_yoy", "balance_yoy"]
    titles = ["Exportacoes YoY", "Importacoes YoY", "Saldo YoY"]
    colors = ["#00d4aa", "#ff6b6b", "#4dabf7"]
    
    for col, yoy_col, title, color in zip([col1, col2, col3], yoy_cols, titles, colors):
        with col:
            if yoy_col in df.columns:
                data = df.dropna(subset=[yoy_col])
                colors_bar = [color if x >= 0 else "#ff4444" for x in data[yoy_col]]
                fig = go.Figure()
                fig.add_trace(go.Bar(x=data["date"], y=data[yoy_col], marker_color=colors_bar, name=title))
                fig.add_hline(y=0, line_color="white", line_width=1)
                fig.update_layout(template="plotly_dark", height=300, title=title,
                                xaxis_title="Data", yaxis_title="%", showlegend=False)
                st.plotly_chart(fig, width="stretch")


def render_seasonality(df):
    """Renderiza sazonalidade"""
    st.subheader("Sazonalidade Mensal")
    numeric_cols = ["exports", "imports", "balance"]
    available = [c for c in numeric_cols if c in df.columns]
    if not available:
        return
    monthly = df.groupby("month")[available].mean().reset_index()
    fig = go.Figure()
    colors = ["#00d4aa", "#ff6b6b", "#4dabf7"]
    for col, color in zip(available, colors):
        fig.add_trace(go.Bar(x=monthly["month"], y=monthly[col], name=col.title(), marker_color=color))
    fig.update_layout(template="plotly_dark", barmode="group", height=400,
                     xaxis_title="Mes", yaxis_title="Media (M USD)",
                     xaxis=dict(tickmode="array", tickvals=list(range(1,13)),
                               ticktext=["Jan","Fev","Mar","Abr","Mai","Jun",
                                        "Jul","Ago","Set","Out","Nov","Dez"]))
    st.plotly_chart(fig, width="stretch")


def render_correlation(df):
    """Renderiza matriz de correlacao"""
    st.subheader("Matriz de Correlacao")
    numeric_cols = ["exports", "imports", "balance", "gdp_growth",
                   "inflation", "unemployment", "industrial_production"]
    available = [c for c in numeric_cols if c in df.columns]
    if len(available) < 2:
        st.warning("Dados insuficientes para correlacao")
        return
    corr = df[available].corr()
    fig = px.imshow(corr.values, labels=dict(color="Correlacao"),
                   x=[c.replace("_", " ").title() for c in available],
                   y=[c.replace("_", " ").title() for c in available],
                   color_continuous_scale="RdYlGn", zmin=-1, zmax=1, template="plotly_dark")
    fig.update_traces(text=np.round(corr.values, 2), texttemplate="%{text}")
    fig.update_layout(height=500)
    st.plotly_chart(fig, width="stretch")


def render_scatter(df):
    """Renderiza scatter plot"""
    st.subheader("Relacao Exportacoes vs Importacoes")
    if "imports" not in df.columns or "exports" not in df.columns:
        st.info("Colunas exports/imports nao disponiveis")
        return

    plot_df = df.dropna(subset=["imports", "exports"]).copy()
    if len(plot_df) == 0:
        st.info("Dados insuficientes para scatter plot")
        return

    scatter_kwargs = {
        "x": "imports",
        "y": "exports",
        "color": "year",
        "template": "plotly_dark",
        "color_continuous_scale": "viridis",
        "title": "Exportacoes vs Importacoes (cor=ano, tamanho=|saldo|)",
    }
    hover = ["date"]
    if "coverage_ratio" in plot_df.columns:
        hover.append("coverage_ratio")
    scatter_kwargs["hover_data"] = hover

    if "balance" in plot_df.columns:
        plot_df["balance_size"] = plot_df["balance"].abs().clip(lower=1)
        scatter_kwargs["size"] = "balance_size"

    fig = px.scatter(plot_df, **scatter_kwargs)
    z = np.polyfit(plot_df["imports"], plot_df["exports"], 1)
    p = np.poly1d(z)
    x_line = np.linspace(plot_df["imports"].min(), plot_df["imports"].max(), 100)
    fig.add_trace(go.Scatter(x=x_line, y=p(x_line), mode="lines",
                            name="Tendencia", line=dict(color="#ffd43b", dash="dash")))
    fig.update_layout(height=500)
    st.plotly_chart(fig, width="stretch")


def render_volatility(df):
    """Renderiza volatilidade"""
    st.subheader("Volatilidade (12 Meses)")
    vol_cols = ["exports_vol", "imports_vol"]
    colors = ["#00d4aa", "#ff6b6b"]
    fig = go.Figure()
    for col, color in zip(vol_cols, colors):
        if col in df.columns:
            vol_data = df.dropna(subset=[col])
            fig.add_trace(go.Scatter(x=vol_data["date"], y=vol_data[col], mode="lines",
                                    name=col.replace("_", " ").title(), line=dict(color=color, width=2),
                                    fill="tozeroy"))
    fig.update_layout(template="plotly_dark", height=400, xaxis_title="Data", yaxis_title="Desvio Padrao (M USD)")
    st.plotly_chart(fig, width="stretch")


def render_economic_indicators(df):
    """Renderiza indicadores economicos"""
    st.subheader("Indicadores Economicos")
    indicators = ["gdp_growth", "inflation", "unemployment", "industrial_production"]
    colors = ["#da77f2", "#ff922b", "#ff6b6b", "#4dabf7"]
    fig = go.Figure()
    for col, color in zip(indicators, colors):
        if col in df.columns:
            fig.add_trace(go.Scatter(x=df["date"], y=df[col], mode="lines",
                                    name=col.replace("_", " ").title(), line=dict(color=color, width=2)))
    fig.add_hline(y=0, line_color="white", line_width=0.5, opacity=0.5)
    fig.update_layout(template="plotly_dark", height=400, xaxis_title="Data", yaxis_title="% / Indice")
    st.plotly_chart(fig, width="stretch")


def render_moving_averages(df):
    """Renderiza medias moveis"""
    st.subheader("Medias Moveis")
    fig = go.Figure()
    if "exports" in df.columns:
        fig.add_trace(go.Scatter(x=df["date"], y=df["exports"], mode="lines",
                                name="Exportacoes", line=dict(color="#00d4aa", width=1)))
    if "exports_ma3" in df.columns:
        fig.add_trace(go.Scatter(x=df["date"], y=df["exports_ma3"], mode="lines",
                                name="Exp MA3", line=dict(color="#00d4aa", width=2, dash="dash")))
    if "exports_ma12" in df.columns:
        fig.add_trace(go.Scatter(x=df["date"], y=df["exports_ma12"], mode="lines",
                                name="Exp MA12", line=dict(color="#00d4aa", width=3)))
    if "imports" in df.columns:
        fig.add_trace(go.Scatter(x=df["date"], y=df["imports"], mode="lines",
                                name="Importacoes", line=dict(color="#ff6b6b", width=1)))
    if "imports_ma3" in df.columns:
        fig.add_trace(go.Scatter(x=df["date"], y=df["imports_ma3"], mode="lines",
                                name="Imp MA3", line=dict(color="#ff6b6b", width=2, dash="dash")))
    if "imports_ma12" in df.columns:
        fig.add_trace(go.Scatter(x=df["date"], y=df["imports_ma12"], mode="lines",
                                name="Imp MA12", line=dict(color="#ff6b6b", width=3)))
    fig.update_layout(template="plotly_dark", height=400, xaxis_title="Data", yaxis_title="M USD",
                     legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1))
    st.plotly_chart(fig, width="stretch")


def render_data_table(df):
    """Renderiza tabela de dados"""
    st.subheader("Dados Brutos")
    with st.expander("Ver tabela completa"):
        st.dataframe(df.tail(50), width="stretch")
        csv = df.to_csv(index=False).encode("utf-8")
        st.download_button(label="Download CSV", data=csv,
                          file_name="taiwan_economic_data.csv", mime="text/csv")


def render_production_status():
    """Renderiza status de producao no sidebar"""
    st.sidebar.markdown("---")
    st.sidebar.subheader("🔄 Status de Producao")
    
    history = load_execution_history(5)
    if len(history) > 0:
        for _, row in history.iterrows():
            status_color = "🟢" if row["status"] == "SUCCESS" else "🔴"
            st.sidebar.text(f"{status_color} {row['execution_date'][:16]}")
            st.sidebar.caption(f"  {row['data_source']} | {row['records_count']} regs | {row['duration_seconds']:.1f}s")
    else:
        st.sidebar.info("Nenhuma execucao registrada")
    
    alerts = load_alerts()
    if len(alerts) > 0:
        st.sidebar.markdown("---")
        st.sidebar.subheader("⚠️ Alertas Ativos")
        for _, alert in alerts.iterrows():
            severity_color = "🔴" if alert["severity"] == "CRITICAL" else "🟡"
            st.sidebar.warning(f"{severity_color} {alert['alert_type']}: {alert['message']}")


def render_sidebar():
    """Renderiza sidebar"""
    with st.sidebar:
        st.image("https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Flag_of_the_Republic_of_China.svg/120px-Flag_of_the_Republic_of_China.svg.png", width=100)
        st.title("Taiwan Economic Analyzer")
        st.markdown("---")
        
        st.subheader("Controles")
        st.markdown("**Periodo**")
        date_range = st.date_input("Selecione o periodo",
                                   value=(datetime(2015, 1, 1), datetime.now()),
                                   min_value=datetime(2015, 1, 1), max_value=datetime.now())
        
        st.markdown("**Indicadores**")
        show_exports = st.checkbox("Exportacoes", True)
        show_imports = st.checkbox("Importacoes", True)
        show_balance = st.checkbox("Saldo", True)
        show_economic = st.checkbox("Indicadores Economicos", True)
        show_moea = st.checkbox("Dados MOEA (Setores)", True)
        
        st.markdown("---")
        st.markdown("**Status**")
        if os.path.exists(CONFIG.DB_PATH):
            mtime = os.path.getmtime(CONFIG.DB_PATH)
            last_update = datetime.fromtimestamp(mtime)
            st.success(f"Ultima atualizacao: {last_update.strftime('%Y-%m-%d %H:%M')}")
        else:
            st.warning("Banco de dados nao encontrado")
        
        render_production_status()
        
        st.markdown("---")
        st.caption(f"Auto-refresh: {AUTO_REFRESH_INTERVAL}s")
        st.caption(f"Refresh count: #{refresh_count}")
        
        st.markdown("---")
        st.markdown("Desenvolvido com Python + Streamlit")
        
    return date_range, show_exports, show_imports, show_balance, show_economic, show_moea


# =============================================================================
# FUNCAO PRINCIPAL
# =============================================================================

def main():
    """Funcao principal do dashboard"""
    render_header()
    
    date_range, show_exports, show_imports, show_balance, show_economic, show_moea = render_sidebar()
    
    df = load_data()
    df_moea = load_moea_data() if show_moea else None
    
    if df is None or len(df) == 0:
        st.error("Nenhum dado disponivel. Execute o pipeline primeiro.")
        st.info("Execute: `python main.py` para coletar e processar os dados.")
        return
    
    if len(date_range) == 2:
        start_date, end_date = date_range
        df = df[(df["date"] >= pd.Timestamp(start_date)) & (df["date"] <= pd.Timestamp(end_date))]
    
    render_kpis(df)
    
    tab1, tab2, tab3, tab4, tab5 = st.tabs([
        "📈 Series Temporais", "📊 Analise YoY", "🔄 Sazonalidade & Setores",
        "🔗 Correlacoes", "📋 Dados"
    ])
    
    with tab1:
        if show_exports or show_imports or show_balance:
            render_timeseries(df)
            render_moving_averages(df)
            render_volatility(df)
        else:
            st.info("Selecione indicadores no sidebar")
    
    with tab2:
        render_yoy_analysis(df)
    
    with tab3:
        render_seasonality(df)
        render_scatter(df)
        if show_moea:
            render_moea_sector_analysis(df_moea)
    
    with tab4:
        render_correlation(df)
        if show_economic:
            render_economic_indicators(df)
    
    with tab5:
        render_data_table(df)
    
    st.markdown("---")
    st.markdown("<div style='text-align: center; color: #666;'>Taiwan Economic Analyzer v2.1 - Modo Producao com Auto-Refresh</div>", unsafe_allow_html=True)


if __name__ == "__main__":
    main()