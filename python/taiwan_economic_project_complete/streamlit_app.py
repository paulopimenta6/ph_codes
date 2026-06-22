from __future__ import annotations

import json

import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import streamlit as st

from analysis import (
    forecast_series,
    macro_snapshot,
    seasonal_decomposition_pack,
    stationarity_tests,
    trend_analysis,
)
from config import Settings
from database import load_analysis_results, load_execution_log, load_macro_data, load_trade_data

st.set_page_config(page_title="Taiwan Economic Dashboard", layout="wide")

settings = Settings()

st.title("Taiwan Economic Indicators Dashboard")
st.caption("SQLite + web scraping + cleaning + analytics + continuous pipeline")

trade = load_trade_data(settings.db_path)
macro = load_macro_data(settings.db_path)
analysis_log = load_analysis_results(settings.db_path)
exec_log = load_execution_log(settings.db_path)

if trade.empty:
    st.warning("No data found in SQLite yet. Run `python pipeline.py` first.")
    st.stop()

trade = trade.sort_values("date").copy()
trade["date"] = pd.to_datetime(trade["date"], errors="coerce")

min_date, max_date = trade["date"].min().date(), trade["date"].max().date()
date_range = st.sidebar.date_input(
    "Date range",
    value=(min_date, max_date),
    min_value=min_date,
    max_value=max_date,
)

indicators = [c for c in ["exports", "imports", "balance", "exports_ma12", "imports_ma12", "coverage_ratio", "trade_growth_spread"] if c in trade.columns]
selected = st.sidebar.multiselect("Indicators", indicators, default=["exports", "imports", "balance"])
show_macro = st.sidebar.checkbox("Show macro snapshot", value=True)
show_analysis = st.sidebar.checkbox("Show analytical details", value=True)

if isinstance(date_range, tuple) and len(date_range) == 2:
    start, end = date_range
    mask = (trade["date"].dt.date >= start) & (trade["date"].dt.date <= end)
    trade = trade.loc[mask].copy()

latest = trade.iloc[-1]

c1, c2, c3, c4 = st.columns(4)
c1.metric("Exports", f"{latest['exports']:,.2f}")
c2.metric("Imports", f"{latest['imports']:,.2f}")
c3.metric("Balance", f"{latest['balance']:,.2f}")
c4.metric("Coverage ratio", f"{latest.get('coverage_ratio', float('nan')):,.2f}%")

fig = go.Figure()
for col in selected:
    if col in trade.columns:
        fig.add_trace(go.Scatter(x=trade["date"], y=trade[col], mode="lines", name=col))
fig.update_layout(height=520, legend_title_text="Series", xaxis_title="Date", yaxis_title="Value")
st.plotly_chart(fig, width="stretch")

tab1, tab2, tab3, tab4, tab5 = st.tabs(["EDA", "Seasonality", "Macro", "Data", "Logs"])

with tab1:
    colA, colB = st.columns(2)
    with colA:
        fig_hist = px.histogram(trade, x="exports", nbins=30, title="Exports distribution")
        st.plotly_chart(fig_hist, width="stretch")
    with colB:
        corr_cols = [c for c in ["exports", "imports", "balance", "coverage_ratio", "trade_growth_spread"] if c in trade.columns]
        corr = trade[corr_cols].corr(numeric_only=True)
        fig_corr = px.imshow(corr, text_auto=True, title="Correlation matrix", aspect="auto")
        st.plotly_chart(fig_corr, width="stretch")

    decomp = seasonal_decomposition_pack(trade, "exports")
    if decomp is not None:
        fig_decomp = go.Figure()
        fig_decomp.add_trace(go.Scatter(x=decomp.trend.index, y=decomp.trend, name="Trend"))
        fig_decomp.add_trace(go.Scatter(x=decomp.seasonal.index, y=decomp.seasonal, name="Seasonal"))
        fig_decomp.add_trace(go.Scatter(x=decomp.resid.index, y=decomp.resid, name="Residual"))
        fig_decomp.update_layout(title="Seasonal decomposition - exports", height=450)
        st.plotly_chart(fig_decomp, width="stretch")

    if show_analysis:
        st.subheader("Stationarity and trend")
        st.json(
            {
                "stationarity": stationarity_tests(trade),
                "trend": trend_analysis(trade),
                "forecast": forecast_series(trade, "exports", 12),
            }
        )

with tab2:
    season = trade.groupby("month")[["exports", "imports", "balance"]].mean(numeric_only=True).reset_index()
    season["month"] = season["month"].astype(str)
    fig_season = px.bar(season, x="month", y=["exports", "imports", "balance"], barmode="group", title="Average monthly seasonality")
    st.plotly_chart(fig_season, width="stretch")

with tab3:
    if macro.empty:
        st.info("Macro table is empty.")
    else:
        st.dataframe(macro.sort_values(["indicator", "date"]).tail(100), width="stretch")
        latest_macro = macro.sort_values(["indicator", "date"]).groupby("indicator").tail(1)
        fig_macro = px.bar(latest_macro, x="indicator", y="value", color="indicator", title="Latest macro indicators")
        st.plotly_chart(fig_macro, width="stretch")
        st.subheader("Latest macro snapshot")
        st.json(macro_snapshot(macro))

with tab4:
    st.dataframe(trade, width="stretch")
    st.download_button(
        "Download CSV",
        trade.to_csv(index=False).encode("utf-8"),
        file_name="taiwan_trade_data.csv",
        mime="text/csv",
        width="stretch",
    )

with tab5:
    st.subheader("Execution log")
    if exec_log.empty:
        st.info("No execution logs yet.")
    else:
        st.dataframe(exec_log.head(50), width="stretch")

    st.subheader("Analysis results")
    if analysis_log.empty:
        st.info("No saved analyses yet.")
    else:
        for _, row in analysis_log.head(10).iterrows():
            with st.expander(f"{row['analysis_name']} · {row['created_at']}"):
                try:
                    st.json(json.loads(row["analysis_value"]))
                except Exception:
                    st.write(row["analysis_value"])

if show_macro and not macro.empty:
    st.sidebar.subheader("Latest macro snapshot")
    st.sidebar.json(macro_snapshot(macro))
