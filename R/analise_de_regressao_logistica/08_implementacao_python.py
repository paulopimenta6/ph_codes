#!/usr/bin/env python3
"""
Regressão Logística Binária — Implementação em Python

Ajuste as 6 variáveis de configuração no início e execute:
    python 08_implementacao_python.py
"""

import os
import sys
import warnings
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from scipy import stats
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import (
    confusion_matrix, classification_report, roc_curve, auc,
    ConfusionMatrixDisplay, accuracy_score
)
import statsmodels.api as sm

warnings.filterwarnings("ignore")
plt.rcParams.update({"figure.dpi": 130, "font.size": 11})

# ════════════════════════════════════════════════════════════
#  CONFIGURAÇÃO — ajuste apenas estas variáveis
# ════════════════════════════════════════════════════════════
CAMINHO_CSV = "dados.csv"
VARIAVEL_RESPOSTA = "y"
VARIAVEIS_PRED = ["x1", "x2"]
LIMIAR_DECISAO = 0.5
PROPORCAO_TESTE = 0.30
SEMENTE = 42
# ════════════════════════════════════════════════════════════

def criar_dados_simulados():
    """Gera dados simulados se não existir arquivo"""
    if os.path.exists(CAMINHO_CSV):
        return
    
    print(f"Arquivo não encontrado — gerando dados simulados.")
    rng = np.random.default_rng(SEMENTE)
    n = 350
    x1 = rng.uniform(18, 65, n).round(1)
    x2 = rng.normal(50, 10, n).round(1)
    z = 0.07 * x1 + 0.06 * x2 - 7.0
    p = 1 / (1 + np.exp(-z))
    y = rng.binomial(1, p, n)
    
    df = pd.DataFrame({"y": y, "x1": x1, "x2": x2})
    df.to_csv(CAMINHO_CSV, index=False)
    print(f"✓ '{CAMINHO_CSV}' criado com {n} observações.\n")

def carregar_dados():
    """Carrega e valida dados"""
    raw = pd.read_csv(CAMINHO_CSV)
    print(f"Dataset: {raw.shape[0]} linhas × {raw.shape[1]} colunas")
    print(f"Colunas: {', '.join(raw.columns)}\n")
    
    # Validação
    cols_faltando = [c for c in [VARIAVEL_RESPOSTA] + VARIAVEIS_PRED
                     if c not in raw.columns]
    if cols_faltando:
        sys.exit(f"❌ Colunas ausentes: {', '.join(cols_faltando)}\n"
                 "Ajuste VARIAVEL_RESPOSTA e VARIAVEIS_PRED.")
    
    # Preparação
    dados = raw[[VARIAVEL_RESPOSTA] + VARIAVEIS_PRED].copy()
    dados.rename(columns={VARIAVEL_RESPOSTA: "y"}, inplace=True)
    dados["y"] = dados["y"].astype(int)
    
    # Remover NAs
    n_antes = len(dados)
    dados.dropna(inplace=True)
    if len(dados) < n_antes:
        print(f"✓ Removidas {n_antes - len(dados)} linha(s) com NA.\n")
    
    N1, N0 = dados["y"].sum(), (dados["y"] == 0).sum()
    N = len(dados)
    print(f"Classe 1: {N1} ({100*N1/N:.1f}%) | Classe 0: {N0} ({100*N0/N:.1f}%)\n")
    
    return dados, N1, N0, N

def analise_exploratoria(dados):
    """Gráficos de exploração"""
    fig = plt.figure(figsize=(13, 4.5))
    gs = gridspec.GridSpec(1, 1 + len(VARIAVEIS_PRED), figure=fig)
    
    # Dispersão
    ax0 = fig.add_subplot(gs[0, 0])
    cores = {0: "#C0392B", 1: "#27AE60"}
    for cls, grp in dados.groupby("y"):
        ax0.scatter(grp[VARIAVEIS_PRED[0]],
                   grp[VARIAVEIS_PRED[1]] if len(VARIAVEIS_PRED) > 1 else grp[VARIAVEIS_PRED[0]],
                   c=cores[cls],
                   label="Sucesso (1)" if cls == 1 else "Fracasso (0)",
                   alpha=0.65, edgecolors="white", s=50)
    ax0.set_xlabel(VARIAVEIS_PRED[0])
    ax0.set_title("Dispersão por Classe")
    if len(VARIAVEIS_PRED) > 1:
        ax0.set_ylabel(VARIAVEIS_PRED[1])
    ax0.legend(fontsize=9)
    
    # Boxplots
    for k, var in enumerate(VARIAVEIS_PRED):
        ax = fig.add_subplot(gs[0, k + 1])
        grupos = [dados.loc[dados["y"] == 0, var].values,
                 dados.loc[dados["y"] == 1, var].values]
        bp = ax.boxplot(grupos, patch_artist=True, widths=0.5,
                       medianprops=dict(color="black", linewidth=2))
        for b, cor in zip(bp["boxes"], ["#C0392B", "#27AE60"]):
            b.set_facecolor(cor)
            b.set_alpha(0.75)
        ax.set_xticklabels(["Fracasso (0)", "Sucesso (1)"], fontsize=9)
        ax.set_title(f"Distribuição de {var}")
        ax.set_ylabel(var)
    
    plt.suptitle("Análise Exploratória", fontweight="bold", y=1.00)
    plt.tight_layout()
    plt.savefig("python_eda.png", bbox_inches="tight", dpi=150)
    print("✓ Gráfico: python_eda.png\n")
    plt.show()

def ajustar_modelo(X_tr, y_tr):
    """Ajusta modelo via statsmodels"""
    X_tr_sm = sm.add_constant(X_tr)
    modelo = sm.Logit(y_tr, X_tr_sm).fit(disp=False)
    print("✓ Modelo ajustado com sucesso!\n")
    print(modelo.summary())
    print()
    return modelo, X_tr_sm

def coeficientes_odds_ratios(modelo):
    """Tabela de coeficientes e odds ratios"""
    params = modelo.params
    ep = modelo.bse
    ci = modelo.conf_int()
    
    nomes = ["Intercepto"] + VARIAVEIS_PRED
    df_coef = pd.DataFrame({
        "Coeficiente": params.values.round(4),
        "Erro Padrão": ep.values.round(4),
        "OR": np.exp(params.values).round(4),
        "IC 2,5% (OR)": np.exp(ci.iloc[:, 0].values).round(4),
        "IC 97,5% (OR)": np.exp(ci.iloc[:, 1].values).round(4),
        "Valor-p": modelo.pvalues.values.round(6)
    }, index=nomes)
    
    print("Tabela: Coeficientes e Odds Ratios")
    print(df_coef.to_string())
    print()

def pseudo_r2_mcfadden(modelo, y_tr, N1_tr, N0_tr):
    """Calcula pseudo-R² de McFadden"""
    L_star = modelo.llf
    N_tr = len(y_tr)
    L0 = N1_tr * np.log(N1_tr) + N0_tr * np.log(N0_tr) - N_tr * np.log(N_tr)
    
    r2_mcf = -L_star / L0
    
    print(f"L* (modelo) = {L_star:.4f}")
    print(f"L0 (nulo)   = {L0:.4f}")
    print(f"Pseudo-R² de McFadden: {r2_mcf:.4f}")
    
    avaliacao = ("Fraco" if r2_mcf < 0.20 else
                "Bom" if r2_mcf < 0.40 else
                "Muito bom")
    print(f"Avaliação: {avaliacao}\n")

def teste_razao_verossimilhancas(modelo, y_tr):
    """Teste da razão de verossimilhanças (global)"""
    N_tr = len(y_tr)
    modelo_nulo = sm.Logit(y_tr, np.ones(N_tr)).fit(disp=False)
    
    G = 2 * (modelo.llf - modelo_nulo.llf)
    gl = len(VARIAVEIS_PRED)
    pval = 1 - stats.chi2.cdf(G, df=gl)
    
    print("Teste da Razão de Verossimilhanças (TRV)")
    print(f"  H0: Todos os coeficientes = 0")
    print(f"  H1: Pelo menos um coeficiente ≠ 0")
    print(f"  G-statistic: {G:.4f}")
    print(f"  Graus de liberdade: {gl}")
    print(f"  Valor-p: {pval:.2e}")
    print(f"  Decisão: {'Rejeitar H0 ✓' if pval < 0.05 else 'Não rejeitar'}\n")

def teste_wald(modelo):
    """Teste de Wald (individual)"""
    params = modelo.params
    ep = modelo.bse
    
    w = (params / ep) ** 2
    pw = 1 - stats.chi2.cdf(w, df=1)
    
    nomes = ["Intercepto"] + VARIAVEIS_PRED
    df_wald = pd.DataFrame({
        "Coeficiente": params.values.round(4),
        "Erro Padrão": ep.values.round(4),
        "W-statistic": w.values.round(4),
        "Valor-p": pw.values.round(6),
        "Significância": ["***" if p < 0.001 else "**" if p < 0.01 else "*" if p < 0.05 else ""
                         for p in pw]
    }, index=nomes)
    
    print("Teste de Wald — H0: a_i = 0 | H1: a_i ≠ 0")
    print(df_wald.to_string())
    print()

def avaliar_modelo(modelo_sk, X_te, X_te_sm, y_te):
    """Avalia modelo no conjunto de teste"""
    prob_te = modelo_sk.predict_proba(X_te)[:, 1]
    y_pred = (prob_te >= LIMIAR_DECISAO).astype(int)
    
    acuracia = accuracy_score(y_te, y_pred)
    taxa_erro = 1 - acuracia
    
    print(f"Limiar de decisão: {LIMIAR_DECISAO}")
    print(f"Acurácia:    {acuracia:.4f} ({100*acuracia:.1f}%)")
    print(f"Taxa erro:   {taxa_erro:.4f} ({100*taxa_erro:.1f}%)\n")
    
    print("Matriz de Confusão:")
    print(classification_report(y_te, y_pred,
                               target_names=["Fracasso (0)", "Sucesso (1)"]))
    
    return prob_te, y_pred

def plotar_roc_matriz(y_te, prob_te, y_pred):
    """Plota ROC e matriz de confusão"""
    fig, axes = plt.subplots(1, 2, figsize=(12, 4.5))
    
    # Matriz de confusão
    cm = confusion_matrix(y_te, y_pred)
    ConfusionMatrixDisplay(cm, display_labels=["Fracasso (0)", "Sucesso (1)"]).plot(
        ax=axes[0], colorbar=False, cmap="Blues")
    axes[0].set_title("Matriz de Confusão")
    
    # Curva ROC
    fpr, tpr, _ = roc_curve(y_te, prob_te)
    auc_val = auc(fpr, tpr)
    axes[1].fill_between(fpr, tpr, alpha=0.15, color="#2980B9")
    axes[1].plot(fpr, tpr, color="#2980B9", lw=2.5, label=f"AUC = {auc_val:.3f}")
    axes[1].plot([0, 1], [0, 1], "k--", lw=1.5, label="Aleatório")
    axes[1].set_xlabel("1 − Especificidade")
    axes[1].set_ylabel("Sensibilidade")
    axes[1].set_title("Curva ROC")
    axes[1].legend(loc="lower right")
    axes[1].set_aspect("equal")
    
    plt.tight_layout()
    plt.savefig("python_roc_cm.png", bbox_inches="tight", dpi=150)
    print("✓ Gráfico: python_roc_cm.png\n")
    print(f"AUC: {auc_val:.4f} — ", end="")
    if auc_val >= 0.90:
        print("Excelente ⭐⭐⭐")
    elif auc_val >= 0.80:
        print("Bom ⭐⭐")
    elif auc_val >= 0.70:
        print("Aceitável ⭐")
    else:
        print("Fraco — revisar modelo")
    print()
    plt.show()

def predicao_nova_obs():
    """Predição para nova observação"""
    valores = [45, 55]
    nova_obs = np.array([valores])
    
    modelo_sk_nova = LogisticRegression(max_iter=1000, random_state=SEMENTE)
    X = dados[VARIAVEIS_PRED].values
    y = dados["y"].values
    modelo_sk_nova.fit(X, y)
    
    prob_nova = modelo_sk_nova.predict_proba(nova_obs)[0, 1]
    classe = "Sucesso (1)" if prob_nova >= LIMIAR_DECISAO else "Fracasso (0)"
    
    print("Predição para Nova Observação:")
    for var, val in zip(VARIAVEIS_PRED, valores):
        print(f"  {var} = {val}")
    print(f"\n  Probabilidade: {prob_nova:.4f}")
    print(f"  Classificação: {classe}\n")

# ════════════════════════════════════════════════════════════
# EXECUÇÃO PRINCIPAL
# ════════════════════════════════════════════════════════════

if __name__ == "__main__":
    print("=" * 70)
    print("  REGRESSÃO LOGÍSTICA BINÁRIA — PYTHON")
    print("=" * 70)
    print()
    
    # 1. Dados
    criar_dados_simulados()
    dados, N1, N0, N = carregar_dados()
    
    # 2. EDA
    analise_exploratoria(dados)
    
    # 3. Divisão
    X = dados[VARIAVEIS_PRED].values
    y = dados["y"].values
    X_tr, X_te, y_tr, y_te = train_test_split(
        X, y, test_size=PROPORCAO_TESTE, random_state=SEMENTE, stratify=y
    )
    print(f"✓ Treino: {len(y_tr)} obs. | Teste: {len(y_te)} obs.\n")
    
    # 4. Ajuste
    modelo_sm, X_tr_sm = ajustar_modelo(X_tr, y_tr)
    X_te_sm = sm.add_constant(X_te)
    
    # 5. Coeficientes
    coeficientes_odds_ratios(modelo_sm)
    
    # 6. R² McFadden
    N1_tr = int(y_tr.sum())
    N0_tr = len(y_tr) - N1_tr
    pseudo_r2_mcfadden(modelo_sm, y_tr, N1_tr, N0_tr)
    
    # 7. Testes
    teste_razao_verossimilhancas(modelo_sm, y_tr)
    teste_wald(modelo_sm)
    
    # 8. Predição
    modelo_sk = LogisticRegression(max_iter=1000, random_state=SEMENTE)
    modelo_sk.fit(X_tr, y_tr)
    
    prob_te, y_pred = avaliar_modelo(modelo_sk, X_te, X_te_sm, y_te)
    
    # 9. Visualizações
    plotar_roc_matriz(y_te, prob_te, y_pred)
    
    # 10. Predição nova
    predicao_nova_obs()
    
    print("=" * 70)
    print("  ✓ ANÁLISE COMPLETA!")
    print("=" * 70)
