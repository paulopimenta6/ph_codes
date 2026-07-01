#!/usr/bin/env python3
"""
Regressão Logística Binária — Implementação em Python (foco analítico)

Análise completa: estimação, interpretação de coeficientes/OR,
efeitos marginais, pseudo-R², AIC/BIC, testes TRV e Wald,
Hosmer-Lemeshow, diagnóstico de resíduos e predição.

Ajuste as variáveis de configuração e execute:
    python 08_implementacao_python.py
"""

import os
import sys
import warnings
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_curve, auc, accuracy_score
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
    """Gera dados simulados se nao existir arquivo"""
    if os.path.exists(CAMINHO_CSV):
        return
    print(f"Arquivo nao encontrado — gerando dados simulados.")
    rng = np.random.default_rng(SEMENTE)
    n = 350
    x1 = rng.uniform(18, 65, n).round(1)
    x2 = rng.normal(50, 10, n).round(1)
    z = 0.07 * x1 + 0.06 * x2 - 7.0
    p = 1 / (1 + np.exp(-z))
    y = rng.binomial(1, p, n)
    df = pd.DataFrame({"y": y, "x1": x1, "x2": x2})
    df.to_csv(CAMINHO_CSV, index=False)
    print(f"  '{CAMINHO_CSV}' criado com {n} observacoes.\n")


def carregar_dados():
    """Carrega e valida dados"""
    raw = pd.read_csv(CAMINHO_CSV)
    print(f"Dataset: {raw.shape[0]} linhas x {raw.shape[1]} colunas")
    print(f"Colunas: {', '.join(raw.columns)}\n")

    cols_faltando = [c for c in [VARIAVEL_RESPOSTA] + VARIAVEIS_PRED
                     if c not in raw.columns]
    if cols_faltando:
        sys.exit(f"Colunas ausentes: {', '.join(cols_faltando)}\n"
                 "Ajuste VARIAVEL_RESPOSTA e VARIAVEIS_PRED.")

    dados = raw[[VARIAVEL_RESPOSTA] + VARIAVEIS_PRED].copy()
    dados.rename(columns={VARIAVEL_RESPOSTA: "y"}, inplace=True)
    dados["y"] = dados["y"].astype(int)
    n_antes = len(dados)
    dados.dropna(inplace=True)
    if len(dados) < n_antes:
        print(f"Removidas {n_antes - len(dados)} linha(s) com NA.\n")

    N1, N0 = dados["y"].sum(), (dados["y"] == 0).sum()
    N = len(dados)
    print(f"Classe 1: {N1} ({100*N1/N:.1f}%) | Classe 0: {N0} ({100*N0/N:.1f}%)\n")
    return dados, N1, N0, N


def ajustar_modelo(X_tr, y_tr):
    """Ajusta modelo via statsmodels"""
    X_tr_sm = sm.add_constant(X_tr)
    modelo = sm.Logit(y_tr, X_tr_sm).fit(disp=False)
    print("Modelo ajustado por MV (BFGS).\n")
    print(modelo.summary())
    print()
    return modelo, X_tr_sm


def tabela_coeficientes(modelo):
    """Tabela de coeficientes e odds ratios com IC 95%"""
    params = modelo.params
    ep = modelo.bse
    ci = modelo.conf_int()
    nomes = ["Intercepto"] + VARIAVEIS_PRED

    df_coef = pd.DataFrame({
        "Coeficiente": params.values.round(4),
        "Erro_Padrao": ep.values.round(4),
        "OR": np.exp(params.values).round(4),
        "IC_2.5_OR": np.exp(ci.iloc[:, 0].values).round(4),
        "IC_97.5_OR": np.exp(ci.iloc[:, 1].values).round(4),
        "Valor_p": modelo.pvalues.values.round(6)
    }, index=nomes)

    print("Tabela 1. Coeficientes e Odds Ratios com IC 95%")
    print("Interpretacao: OR > 1 aumenta odds; OR < 1 reduz odds.")
    print("Se o IC 95% do OR excluir 1, efeito significativo (p < 0,05).\n")
    print(df_coef.to_string())
    print()


def efeitos_marginais(modelo, X_tr):
    """Calcula Average Marginal Effects (AME)"""
    X_sm = sm.add_constant(X_tr)
    pi_hat = modelo.predict(X_sm)

    for j, nome in enumerate(VARIAVEIS_PRED):
        beta_j = modelo.params[1 + j]
        ame = np.mean(pi_hat * (1 - pi_hat) * beta_j)
        print(f"AME({nome}) = {ame:.4f}")
    print("Interpretacao: variacao media na probabilidade do evento")
    print("para aumento de 1 unidade na preditora.\n")


def medidas_ajuste(modelo, y_tr):
    """Pseudo-R² de McFadden, AIC, BIC"""
    L_star = modelo.llf
    N_tr = len(y_tr)
    N1_tr = int(y_tr.sum())
    N0_tr = N_tr - N1_tr
    L0 = N1_tr * np.log(N1_tr) + N0_tr * np.log(N0_tr) - N_tr * np.log(N_tr)

    r2_mcf = 1 - L_star / L0
    k = len(modelo.params)
    aic = -2 * L_star + 2 * k
    bic = -2 * L_star + k * np.log(N_tr)

    print("Medidas de Ajuste do Modelo")
    print(f"  L* (modelo)        = {L_star:.4f}")
    print(f"  L0 (nulo)          = {L0:.4f}")
    print(f"  Pseudo-R² McFadden = {r2_mcf:.4f}")
    print(f"  AIC                = {aic:.2f}")
    print(f"  BIC                = {bic:.2f}")

    if r2_mcf < 0.20:
        aval = "Fraco"
    elif r2_mcf < 0.40:
        aval = "Bom"
    else:
        aval = "Muito bom"
    print(f"  Avaliacao           = {aval}")

    print(f"  Deviance nula      = {modelo.llnull * -2:.2f} (gl = {len(modelo.params) - 1})")
    print(f"  Deviance residual  = {modelo.deviance:.2f} (gl = {N_tr - len(modelo.params)})")
    print()


def teste_trv(modelo, y_tr):
    """Teste da Razao de Verossimilhancas (global)"""
    N_tr = len(y_tr)
    modelo_nulo = sm.Logit(y_tr, np.ones(N_tr)).fit(disp=False)
    G = 2 * (modelo.llf - modelo_nulo.llf)
    gl = len(VARIAVEIS_PRED)
    pval = 1 - stats.chi2.cdf(G, df=gl)

    print("Teste da Razao de Verossimilhancas (TRV)")
    print(f"  H0: beta_1 = ... = beta_p = 0")
    print(f"  H1: existe j com beta_j != 0")
    print(f"  G (2 * delta L)   = {G:.4f}")
    print(f"  Graus de liberdade = {gl}")
    print(f"  Valor-p            = {pval:.4e}")
    print(f"  Decisao (alpha = 0,05): {'Rejeitar H0' if pval < 0.05 else 'Nao rejeitar H0'}\n")


def teste_wald(modelo):
    """Teste de Wald (individual)"""
    params = modelo.params
    ep = modelo.bse
    w = (params / ep) ** 2
    pw = 1 - stats.chi2.cdf(w, df=1)
    nomes = ["Intercepto"] + VARIAVEIS_PRED

    df_wald = pd.DataFrame({
        "Coeficiente": params.values.round(4),
        "Erro_Padrao": ep.values.round(4),
        "W_statistic": w.values.round(4),
        "Valor_p": pw.values.round(6),
        "Signif": ["***" if p < 0.001 else "**" if p < 0.01 else "*" if p < 0.05 else ""
                   for p in pw]
    }, index=nomes)

    print("Teste de Wald — H0: beta_j = 0 | H1: beta_j != 0")
    print(df_wald.to_string())
    print("Significancia: *** p < 0,001 | ** p < 0,01 | * p < 0,05\n")


def teste_hosmer_lemeshow(modelo, y_tr, g=10):
    """Teste de Hosmer-Lemeshow para qualidade do ajuste"""
    X_sm = sm.add_constant(modelo.model.exog[:, 1:])
    pi_hat = modelo.predict(X_sm)
    order = np.argsort(pi_hat)
    grupos = np.array_split(order, g)

    C_hat = 0.0
    for grupo in grupos:
        O1 = y_tr[grupo].sum()
        E1 = pi_hat[grupo].sum()
        O0 = len(grupo) - O1
        E0 = (1 - pi_hat[grupo]).sum()
        if E1 > 0:
            C_hat += (O1 - E1)**2 / E1
        if E0 > 0:
            C_hat += (O0 - E0)**2 / E0

    pval = 1 - stats.chi2.cdf(C_hat, df=g - 2)

    print(f"Teste de Hosmer-Lemeshow")
    print(f"  C_hat              = {C_hat:.4f}")
    print(f"  Graus de liberdade = {g - 2}")
    print(f"  Valor-p            = {pval:.4f}")
    print(f"  H0: modelo ajusta-se adequadamente")
    print(f"  Decisao (alpha = 0,05): {'Rejeitar H0 (falta de ajuste)' if pval < 0.05 else 'Nao rejeitar H0'}\n")


def avaliar_modelo(modelo_sk, X_te, y_te):
    """Avalia modelo no conjunto de teste (uso auxiliar)"""
    prob_te = modelo_sk.predict_proba(X_te)[:, 1]
    y_pred = (prob_te >= LIMIAR_DECISAO).astype(int)
    acuracia = accuracy_score(y_te, y_pred)

    print(f"Desempenho no conjunto de teste (uso auxiliar):")
    print(f"  Limiar de decisao: {LIMIAR_DECISAO}")
    print(f"  Acuracia:   {acuracia:.4f} ({100*acuracia:.1f}%)")
    print(f"  Taxa erro:  {1-acuracia:.4f} ({(1-acuracia)*100:.1f}%)\n")
    return prob_te, y_pred


def plotar_roc(y_te, prob_te):
    """plota curva ROC"""
    fpr, tpr, _ = roc_curve(y_te, prob_te)
    auc_val = auc(fpr, tpr)

    fig, ax = plt.subplots(1, 1, figsize=(6, 5))
    ax.fill_between(fpr, tpr, alpha=0.15, color="#2980B9")
    ax.plot(fpr, tpr, color="#2980B9", lw=2.5, label=f"AUC = {auc_val:.3f}")
    ax.plot([0, 1], [0, 1], "k--", lw=1.5, label="Aleatorio")
    ax.set_xlabel("1 - Especificidade")
    ax.set_ylabel("Sensibilidade")
    ax.set_title("Curva ROC")
    ax.legend(loc="lower right")
    ax.set_aspect("equal")
    plt.tight_layout()
    plt.savefig("python_roc.png", bbox_inches="tight", dpi=150)
    print(f"Grafico: python_roc.png")
    print(f"AUC = {auc_val:.4f} — ", end="")
    if auc_val >= 0.90:
        print("Excelente\n")
    elif auc_val >= 0.80:
        print("Bom\n")
    elif auc_val >= 0.70:
        print("Aceitavel\n")
    else:
        print("Fraco\n")
    plt.close()


def diagnostico_residuos(modelo, X_tr, y_tr):
    """Diagnostico de residuos"""
    X_sm = sm.add_constant(X_tr)
    pi_hat = modelo.predict(X_sm)
    res_pearson = (y_tr - pi_hat) / np.sqrt(pi_hat * (1 - pi_hat))
    res_deviance = np.sign(y_tr - pi_hat) * np.sqrt(
        -2 * (y_tr * np.log(pi_hat + 1e-10) + (1 - y_tr) * np.log(1 - pi_hat + 1e-10))
    )

    print("Diagnostico de Residuos")
    print(f"  Residuos de Pearson:")
    print(f"    Min = {res_pearson.min():.3f}, Max = {res_pearson.max():.3f}")
    print(f"    Proporcao |r| > 2: {100*np.mean(np.abs(res_pearson) > 2):.1f}%")
    print(f"  Residuos Deviance:")
    print(f"    Min = {res_deviance.min():.3f}, Max = {res_deviance.max():.3f}")
    print(f"    Proporcao |d| > 2: {100*np.mean(np.abs(res_deviance) > 2):.1f}%\n")


def predicao_nova_obs():
    """Predicao para nova observacao (uso auxiliar)"""
    valores = [45, 55]
    nova_obs = np.array([valores])

    modelo_sk_nova = LogisticRegression(max_iter=1000, random_state=SEMENTE)
    X_full = dados[VARIAVEIS_PRED].values
    y_full = dados["y"].values
    modelo_sk_nova.fit(X_full, y_full)

    prob_nova = modelo_sk_nova.predict_proba(nova_obs)[0, 1]
    classe = "Sucesso (1)" if prob_nova >= LIMIAR_DECISAO else "Fracasso (0)"

    print("Predicao para nova observacao (uso auxiliar):")
    for var, val in zip(VARIAVEIS_PRED, valores):
        print(f"  {var} = {val}")
    print(f"  Probabilidade: {prob_nova:.4f}")
    print(f"  Classificacao: {classe}\n")


# ════════════════════════════════════════════════════════════
# EXECUÇÃO PRINCIPAL
# ════════════════════════════════════════════════════════════

if __name__ == "__main__":
    print("=" * 70)
    print("  REGRESSÃO LOGÍSTICA BINÁRIA — ANÁLISE (PYTHON)")
    print("=" * 70)
    print()

    # 1. Dados
    criar_dados_simulados()
    dados, N1, N0, N = carregar_dados()

    # 2. Divisão treino/teste
    X = dados[VARIAVEIS_PRED].values
    y = dados["y"].values
    X_tr, X_te, y_tr, y_te = train_test_split(
        X, y, test_size=PROPORCAO_TESTE, random_state=SEMENTE, stratify=y
    )
    print(f"Treino: {len(y_tr)} obs. | Teste: {len(y_te)} obs.\n")

    # 3. Ajuste do modelo (statsmodels - para inferencia)
    modelo_sm, X_tr_sm = ajustar_modelo(X_tr, y_tr)

    # 4. Coeficientes e OR (ANALISE)
    tabela_coeficientes(modelo_sm)

    # 5. Efeitos Marginais (ANALISE)
    efeitos_marginais(modelo_sm, X_tr)

    # 6. Medidas de Ajuste (ANALISE)
    medidas_ajuste(modelo_sm, y_tr)

    # 7. Teste TRV (ANALISE)
    teste_trv(modelo_sm, y_tr)

    # 8. Teste de Wald (ANALISE)
    teste_wald(modelo_sm)

    # 9. Hosmer-Lemeshow (ANALISE - diagnostico)
    teste_hosmer_lemeshow(modelo_sm, y_tr)

    # 10. Diagnostico de Residuos (ANALISE)
    diagnostico_residuos(modelo_sm, X_tr, y_tr)

    # 11. Avaliacao no teste (auxiliar)
    # Usamos sklearn para metricas preditivas (nao analiticas)
    modelo_sk = LogisticRegression(max_iter=1000, random_state=SEMENTE)
    modelo_sk.fit(X_tr, y_tr)
    prob_te, y_pred = avaliar_modelo(modelo_sk, X_te, y_te)

    # 12. Curva ROC (auxiliar)
    plotar_roc(y_te, prob_te)

    print("=" * 70)
    print("  ANALISE COMPLETA")
    print("=" * 70)
