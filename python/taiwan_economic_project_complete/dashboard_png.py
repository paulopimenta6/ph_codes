from __future__ import annotations

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from analysis import seasonal_decomposition_pack


def make_dashboard_png(trade_df: pd.DataFrame, macro_df: pd.DataFrame, output_path: str | Path) -> Path:
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    df = trade_df.copy()
    if df.empty:
        raise ValueError("trade_df is empty")

    df["date"] = pd.to_datetime(df["date"])
    df = df.sort_values("date")

    fig = plt.figure(figsize=(20, 24), dpi=160)
    gs = fig.add_gridspec(4, 2, height_ratios=[2.1, 1.4, 1.4, 1.2], hspace=0.35, wspace=0.25)

    ax1 = fig.add_subplot(gs[0, :])
    ax1.plot(df["date"], df["exports"], label="Exports", linewidth=2.2)
    ax1.plot(df["date"], df["imports"], label="Imports", linewidth=2.2)
    ax1.plot(df["date"], df["balance"], label="Balance", linewidth=1.8)
    if "exports_ma12" in df.columns:
        ax1.plot(df["date"], df["exports_ma12"], label="Exports MA12", linestyle="--", alpha=0.8)
    ax1.set_title("Taiwan Economic Dashboard — Monthly Trade Series", fontsize=16, weight="bold")
    ax1.set_ylabel("USD million")
    ax1.legend(ncol=4, fontsize=9)
    ax1.grid(True, alpha=0.2)

    ax2 = fig.add_subplot(gs[1, 0])
    for col, label in [("exports_yoy", "Exports YoY"), ("imports_yoy", "Imports YoY"), ("balance_yoy", "Balance YoY")]:
        if col in df.columns:
            ax2.plot(df["date"], df[col] * 100, label=label)
    ax2.axhline(0, color="black", linewidth=0.8)
    ax2.set_title("Year-over-Year Dynamics")
    ax2.legend(fontsize=8)
    ax2.grid(True, alpha=0.2)

    ax3 = fig.add_subplot(gs[1, 1])
    season = df.groupby("month")[["exports", "imports", "balance"]].mean(numeric_only=True)
    season.plot(kind="bar", ax=ax3)
    ax3.set_title("Average Monthly Seasonality")
    ax3.set_xlabel("Month")
    ax3.grid(True, axis="y", alpha=0.2)

    ax4 = fig.add_subplot(gs[2, 0])
    corr_cols = [c for c in ["exports", "imports", "balance", "coverage_ratio", "trade_growth_spread"] if c in df.columns]
    corr = df[corr_cols].corr(numeric_only=True)
    im = ax4.imshow(corr.values, vmin=-1, vmax=1)
    ax4.set_xticks(range(len(corr.columns)))
    ax4.set_xticklabels(corr.columns, rotation=20, ha="right")
    ax4.set_yticks(range(len(corr.index)))
    ax4.set_yticklabels(corr.index)
    ax4.set_title("Correlation Matrix")
    for i in range(corr.shape[0]):
        for j in range(corr.shape[1]):
            ax4.text(j, i, f"{corr.iloc[i, j]:.2f}", ha="center", va="center", fontsize=10, weight="bold")
    fig.colorbar(im, ax=ax4, fraction=0.046, pad=0.04)

    ax5 = fig.add_subplot(gs[2, 1])
    decomp = seasonal_decomposition_pack(df, "exports")
    if decomp is not None:
        decomp.trend.plot(ax=ax5, label="Trend")
        decomp.seasonal.plot(ax=ax5, label="Seasonal", alpha=0.7)
        ax5.set_title("Seasonal Decomposition — Exports")
        ax5.legend(fontsize=8)
    else:
        ax5.text(0.5, 0.5, "Not enough data for decomposition", ha="center", va="center")
        ax5.axis("off")

    ax6 = fig.add_subplot(gs[3, :])
    ax6.axis("off")
    latest = df.iloc[-1]
    summary = [
        f"Latest date: {latest['date'].date()}",
        f"Exports: {latest['exports']:,.2f} | Imports: {latest['imports']:,.2f} | Balance: {latest['balance']:,.2f}",
        f"Exports YoY: {latest['exports_yoy'] * 100:,.2f}%" if pd.notna(latest.get("exports_yoy")) else "Exports YoY: n/a",
        f"Coverage ratio: {latest.get('coverage_ratio', np.nan):,.2f}%" if pd.notna(latest.get("coverage_ratio")) else "Coverage ratio: n/a",
        f"Anomalies flagged: {int(df['is_anomaly'].sum()) if 'is_anomaly' in df.columns else 0}",
    ]
    ax6.text(0.01, 0.9, "\n".join(summary), fontsize=14, va="top", family="monospace")

    macro_latest = macro_df.sort_values(["indicator", "date"]).groupby("indicator").tail(1) if not macro_df.empty else pd.DataFrame()
    if not macro_latest.empty:
        macro_lines = ["Latest macro snapshot:"]
        for _, row in macro_latest.head(8).iterrows():
            macro_lines.append(f"- {row['indicator']}: {row['value']} {row.get('unit') or ''}")
        ax6.text(0.52, 0.9, "\n".join(macro_lines), fontsize=12, va="top", family="monospace")

    fig.suptitle("Taiwan Economic Indicators — Automated Dashboard", fontsize=20, weight="bold", y=0.995)
    fig.savefig(output_path, bbox_inches="tight")
    plt.close(fig)
    return output_path
