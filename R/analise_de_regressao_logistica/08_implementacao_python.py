#!/usr/bin/env python3
"""
Regressão Logística Binária — Implementação em Python (foco analítico)

Análise completa: estimação, interpretação de coeficientes/OR,
efeitos marginais (AME e MEM), pseudo-R², AIC/BIC, testes TRV e Wald,
Hosmer-Lemeshow, diagnóstico de resíduos e predição.

Ajuste as variáveis de configuração e execute:
    python 08_implementacao_python.py

(Parte do tutorial "Regressão Logística Binária — Análise",
 capítulos 1 a 9 na documentação. Rode junto com o script R
 equivalente na mesma pasta para comparar os resultados — ambos
 compartilham o mesmo dados.csv.)
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


def verificar_epv(y):
    """Regra dos ~10 eventos por parâmetro (Capítulo 1)."""
    n_param = len(VARIAVEIS_PRED) + 1
    minimo = 10 * n_param
    eventos = min(int(y.sum()), len(y) - int(y.sum()))

    if eventos < minimo:
        print(f"AVISO (EPV): {eventos} eventos disponíveis para {n_param} "
              f"parâmetros.")
        print(f"    Regra do Capítulo 1 pede ~10 eventos por parâmetro "
              f"(recomendado: >= {minimo}).")
        print("    Wald e valor-p perdem confiabilidade — volte ao Capítulo 5.\n")
    else:
        print(f"EPV ok: {eventos} eventos para {n_param} parâmetros — "
              "respeita a regra dos ~10.\n")


def criar_dados_simulados():
    """Gera dados simulados se não existir o arquivo."""
    if os.path.exists(CAMINHO_CSV):
        return
    print("Arquivo não encontrado — gerando dados simulados.")
    rng = np.random.default_rng(SEMENTE)
    n = 350
    x1 = rng.uniform(18, 65, n).round(1)
    x2 = rng.normal(50, 10, n).round(1)
    z = 0.07 * x1 + 0.06 * x2 - 7.0
    p = 1 / (1 + np.exp(-z))
    y = rng.binomial(1, p, n)
    df = pd.DataFrame({"y": y, "x1": x1, "x2": x2})
    df.to_csv(CAMINHO_CSV, index=False)
    print(f"  '{CAMINHO_CSV}' criado com {n} observações.\n")


def carregar_dados():
    """Carrega e valida os dados."""
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


def analise_exploratoria(dados):
    """Gráfico exploratório: dispersão por classe + boxplots das preditoras."""
    cores = {0: "#C0392B", 1: "#27AE60"}
    rotulos = {0: "Fracasso (0)", 1: "Sucesso (1)"}

    fig, axes = plt.subplots(1, 1 + len(VARIAVEIS_PRED),
                             figsize=(13, 4.5))
    axes = np.atleast_1d(axes)

    for classe, cor in cores.items():
        sub = dados[dados["y"] == classe]
        axes[0].scatter(sub[VARIAVEIS_PRED[0]], sub[VARIAVEIS_PRED[1]],
                        c=cor, alpha=0.65, s=25, label=rotulos[classe])
    axes[0].set_xlabel(VARIAVEIS_PRED[0])
    axes[0].set_ylabel(VARIAVEIS_PRED[1])
    axes[0].set_title("Dispersão por Classe")
    axes[0].legend(loc="best")

    for ax, var in zip(axes[1:], VARIAVEIS_PRED):
        dados.boxplot(column=var, by="y", ax=ax, grid=False)
        ax.set_title(f"Distribuição de {var}")
        ax.set_xlabel("Classe")
        ax.set_ylabel(var)

    plt.tight_layout()
    plt.savefig("python_eda.png", bbox_inches="tight", dpi=150)
    plt.close()
    print("Gráfico: python_eda.png\n")


def ajustar_modelo(X_tr, y_tr):
    """Ajusta o modelo logístico via statsmodels (para inferência)."""
    X_tr_sm = sm.add_constant(X_tr)
    modelo = sm.Logit(y_tr, X_tr_sm).fit(disp=False)
    print("Modelo ajustado por MV otimização numérica (BFGS).\n")
    print(modelo.summary())
    print()
    return modelo


def tabela_coeficientes(modelo):
    """Tabela de coeficientes e odds ratios com IC 95%."""
    params = modelo.params
    ep = modelo.bse
    ci = np.asarray(modelo.conf_int())
    nomes = ["Intercepto"] + VARIAVEIS_PRED

    df_coef = pd.DataFrame({
        "Coeficiente": np.asarray(params).round(4),
        "Erro_Padrão": np.asarray(ep).round(4),
        "OR": np.exp(np.asarray(params)).round(4),
        "IC_2.5_OR": np.exp(ci[:, 0]).round(4),
        "IC_97.5_OR": np.exp(ci[:, 1]).round(4),
        "Valor_p": np.asarray(modelo.pvalues).round(6)
    }, index=nomes)

    print("Tabela 1. Coeficientes e Odds Ratios com IC 95%")
    print("Interpretação: OR > 1 aumenta os odds; OR < 1 reduz os odds.")
    print("Se o IC 95% do OR excluir 1, efeito significativo (p < 0,05).\n")
    print(df_coef.to_string())
    print()


def efeitos_marginais(modelo, X_tr):
    """Efeitos marginais: AME (média nas observações) e MEM (na média)."""
    X_sm = sm.add_constant(X_tr)
    pi_hat = modelo.predict(X_sm)

    media = X_tr.mean(axis=0)
    z_bar = modelo.params[0] + np.dot(media, modelo.params[1:])
    pi_bar = 1 / (1 + np.exp(-z_bar))

    print("Efeitos Marginais")
    print("  AME = média dos efeitos nas observações | MEM = efeito na média das preditoras")
    for j, nome in enumerate(VARIAVEIS_PRED):
        beta_j = modelo.params[1 + j]
        ame = np.mean(pi_hat * (1 - pi_hat) * beta_j)
        mem = pi_bar * (1 - pi_bar) * beta_j
        print(f"  AME({nome}) = {ame:.4f} | MEM({nome}) = {mem:.4f}")
    print(f"  Probabilidade prevista na média das preditoras: pi_bar = {pi_bar:.4f}")
    print("  Interpretação: variação média na probabilidade do evento")
    print("  para aumento de 1 unidade na preditora (em pontos percentuais).\n")


def medidas_ajuste(modelo, y_tr):
    """Pseudo-R² de McFadden, AIC, BIC e deviances (com gl corretos)."""
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
    print(f"  Avaliação          = {aval}")

    # Deviance: graus de liberdade corretos (nulo = N-1; residual = N-k)
    print(f"  Deviance nula      = {-2 * modelo.llnull:.2f} (gl = {N_tr - 1})")
    print(f"  Deviance residual  = {-2 * modelo.llf:.2f} (gl = {N_tr - k})")
    print()


def teste_trv(modelo, y_tr):
    """Teste da Razão de Verossimilhanças (global — Capítulo 5)."""
    N_tr = len(y_tr)
    modelo_nulo = sm.Logit(y_tr, np.ones(N_tr)).fit(disp=False)
    G = 2 * (modelo.llf - modelo_nulo.llf)
    gl = len(VARIAVEIS_PRED)
    pval = 1 - stats.chi2.cdf(G, df=gl)

    print("Teste da Razão de Verossimilhanças (TRV)")
    print("  H0: beta_1 = ... = beta_p = 0")
    print("  H1: existe j com beta_j != 0")
    print(f"  G (2 * delta L)   = {G:.4f}")
    print(f"  Graus de liberdade = {gl}")
    print(f"  Valor-p            = {pval:.4e}")
    decisao = "Rejeitar H0" if pval < 0.05 else "Não rejeitar H0"
    print(f"  Decisão (alpha = 0,05): {decisao}\n")


def teste_wald(modelo):
    """Teste de Wald (individual — Capítulo 5)."""
    params = modelo.params
    ep = modelo.bse
    w = (params / ep) ** 2
    pw = 1 - stats.chi2.cdf(w, df=1)
    nomes = ["Intercepto"] + VARIAVEIS_PRED

    df_wald = pd.DataFrame({
        "Coeficiente": np.asarray(params).round(4),
        "Erro_Padrão": np.asarray(ep).round(4),
        "W_statistic": np.asarray(w).round(4),
        "Valor_p": np.asarray(pw).round(6),
        "Signif": ["***" if p < 0.001 else "**" if p < 0.01 else "*" if p < 0.05 else ""
                   for p in pw]
    }, index=nomes)

    print("Teste de Wald — H0: beta_j = 0 | H1: beta_j != 0")
    print(df_wald.to_string())
    print("Significância: *** p < 0,001 | ** p < 0,01 | * p < 0,05\n")


def teste_hosmer_lemeshow(modelo, y_tr, g=10):
    """Teste de Hosmer-Lemeshow para qualidade do ajuste (Capítulo 4)."""
    pi_hat = modelo.predict()  # predições no conjunto de treino (alinhadas a y_tr)
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

    print("Teste de Hosmer-Lemeshow")
    print(f"  C_hat              = {C_hat:.4f}")
    print(f"  Graus de liberdade = {g - 2}")
    print(f"  Valor-p            = {pval:.4f}")
    print("  H0: o modelo se ajusta adequadamente")
    decisao = "Rejeitar H0 (falta de ajuste)" if pval < 0.05 else "Não rejeitar H0"
    print(f"  Decisão (alpha = 0,05): {decisao}\n")


def avaliar_modelo(modelo_sk, X_te, y_te):
    """Avalia o modelo no teste (apoio preditivo, não decide a análise)."""
    prob_te = modelo_sk.predict_proba(X_te)[:, 1]
    y_pred = (prob_te >= LIMIAR_DECISAO).astype(int)
    acuracia = accuracy_score(y_te, y_pred)

    print("Desempenho no conjunto de teste (uso auxiliar):")
    print(f"  Limiar de decisão: {LIMIAR_DECISAO}")
    print(f"  Acurácia:   {acuracia:.4f} ({100*acuracia:.1f}%)")
    print(f"  Taxa de erro:  {1-acuracia:.4f} ({(1-acuracia)*100:.1f}%)\n")
    return prob_te, y_pred


def plotar_roc(y_te, prob_te):
    """Plota a curva ROC (apoio preditivo)."""
    fpr, tpr, _ = roc_curve(y_te, prob_te)
    auc_val = auc(fpr, tpr)

    fig, ax = plt.subplots(1, 1, figsize=(6, 5))
    ax.fill_between(fpr, tpr, alpha=0.15, color="#2980B9")
    ax.plot(fpr, tpr, color="#2980B9", lw=2.5, label=f"AUC = {auc_val:.3f}")
    ax.plot([0, 1], [0, 1], "k--", lw=1.5, label="Aleatório")
    ax.set_xlabel("1 - Especificidade")
    ax.set_ylabel("Sensibilidade")
    ax.set_title("Curva ROC")
    ax.legend(loc="lower right")
    ax.set_aspect("equal")
    plt.tight_layout()
    plt.savefig("python_roc.png", bbox_inches="tight", dpi=150)
    print("Gráfico: python_roc.png")
    print(f"AUC = {auc_val:.4f} — ", end="")
    if auc_val >= 0.90:
        print("Excelente\n")
    elif auc_val >= 0.80:
        print("Bom\n")
    elif auc_val >= 0.70:
        print("Aceitável\n")
    else:
        print("Fraco\n")
    plt.close()


def diagnostico_residuos(modelo):
    """Diagnóstico de resíduos (Pearson, deviance, studentizados, leverage)."""
    # Cálculo explícito das fórmulas do Capítulo 4 (didático):
    y = modelo.model.endog
    pi_hat = modelo.predict()
    hat = modelo.get_influence().hat_matrix_diag

    res_pearson = (y - pi_hat) / np.sqrt(pi_hat * (1 - pi_hat))
    res_deviance = np.sign(y - pi_hat) * np.sqrt(
        -2 * (y * np.log(pi_hat + 1e-10)
              + (1 - y) * np.log(1 - pi_hat + 1e-10))
    )
    res_student = res_pearson / np.sqrt(1 - hat)

    print("Diagnóstico de Resíduos")
    print("  Resíduos de Pearson:")
    print(f"    Min = {res_pearson.min():.3f}, Max = {res_pearson.max():.3f}")
    print(f"    Proporção |r| > 2: {100*np.mean(np.abs(res_pearson) > 2):.1f}%")
    print("  Resíduos Deviance:")
    print(f"    Min = {res_deviance.min():.3f}, Max = {res_deviance.max():.3f}")
    print(f"    Proporção |d| > 2: {100*np.mean(np.abs(res_deviance) > 2):.1f}%")
    print("  Resíduos Studentizados (Pearson / sqrt(1 - leverage)):")
    print(f"    Min = {res_student.min():.3f}, Max = {res_student.max():.3f}")
    print(f"    Proporção |rs| > 2: {100*np.mean(np.abs(res_student) > 2):.1f}% "
          "(investigar esses pontos)")
    print(f"  Leverage: média = {hat.mean():.4f} "
          f"(esperado = {len(modelo.params) / len(res_pearson):.4f})\n")


def predicao_nova_obs(modelo):
    """Predição para nova observação (apoio preditivo)."""
    valores = [45, 55]
    nova_obs = np.array([valores], dtype=float)
    X_nova = sm.add_constant(nova_obs, has_constant="add")
    prob_nova = modelo.predict(X_nova)[0]
    classe = "Sucesso (1)" if prob_nova >= LIMIAR_DECISAO else "Fracasso (0)"

    print("Predição para nova observação (uso auxiliar):")
    for var, val in zip(VARIAVEIS_PRED, valores):
        print(f"  {var} = {val}")
    print(f"  Probabilidade: {prob_nova:.4f}")
    print(f"  Classificação: {classe}\n")


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

    # 2. EDA
    analise_exploratoria(dados)

    # 3. Divisão treino/teste (estratificada)
    X = dados[VARIAVEIS_PRED].values
    y = dados["y"].values
    X_tr, X_te, y_tr, y_te = train_test_split(
        X, y, test_size=PROPORCAO_TESTE, random_state=SEMENTE, stratify=y
    )
    print(f"Treino: {len(y_tr)} obs. | Teste: {len(y_te)} obs.\n")

    # 3b. Checagem EPV na amostra de treino (Capítulo 1)
    verificar_epv(y_tr)

    # 4. Ajuste do modelo (statsmodels — para inferência)
    modelo_sm = ajustar_modelo(X_tr, y_tr)

    # 5. Coeficientes e OR (ANÁLISE)
    tabela_coeficientes(modelo_sm)

    # 6. Efeitos Marginais (ANÁLISE)
    efeitos_marginais(modelo_sm, X_tr)

    # 7. Medidas de Ajuste (ANÁLISE)
    medidas_ajuste(modelo_sm, y_tr)

    # 8. Teste TRV (ANÁLISE)
    teste_trv(modelo_sm, y_tr)

    # 9. Teste de Wald (ANÁLISE)
    teste_wald(modelo_sm)

    # 10. Hosmer-Lemeshow (ANÁLISE - diagnóstico)
    teste_hosmer_lemeshow(modelo_sm, y_tr)

    # 11. Diagnóstico de Resíduos (ANÁLISE)
    diagnostico_residuos(modelo_sm)

    # 12. Avaliação no teste (apoio preditivo)
    modelo_sk = LogisticRegression(max_iter=1000, random_state=SEMENTE)
    modelo_sk.fit(X_tr, y_tr)
    prob_te, y_pred = avaliar_modelo(modelo_sk, X_te, y_te)

    # 13. Curva ROC (apoio preditivo)
    plotar_roc(y_te, prob_te)

    # 14. Predição para nova observação (apoio preditivo)
    predicao_nova_obs(modelo_sm)

    print("=" * 70)
    print("  ANÁLISE COMPLETA")
    print("=" * 70)