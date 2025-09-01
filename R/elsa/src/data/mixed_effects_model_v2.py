import pandas as pd
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Carregar os dados
dados = pd.read_csv("/home/ubuntu/upload/dados_long.csv")

# Identificar colunas numéricas para usar como preditores fixos
fixed_effects_candidates = [col for col in dados.columns if dados[col].dtype in ["float64", "int64"] and col not in ["id_elsa", "onda", "diabetes", "taxa_filt"]]

# Lista de todas as colunas a serem usadas no modelo (dependente + preditoras)
model_cols = ["taxa_filt"] + fixed_effects_candidates

# Remover linhas com valores ausentes em qualquer uma das colunas do modelo
dados_limpos = dados.dropna(subset=model_cols)

# Converter id_elsa para tipo categórico
dados_limpos["id_elsa"] = dados_limpos["id_elsa"].astype("category")

# --- Função para ajustar e retornar o AIC de um modelo ---
def fit_and_get_aic(formula, data, groups):
    try:
        model = smf.mixedlm(formula, data, groups=groups)
        result = model.fit(reml=False) # Usar ML para AIC/BIC comparáveis
        return result.aic
    except Exception as e:
        # print(f"Erro ao ajustar o modelo com a fórmula {formula}: {e}")
        return np.inf # Retorna infinito para modelos que não convergem ou dão erro

# --- Seleção de Variáveis Stepwise (Forward Selection) baseada em AIC ---
best_aic = np.inf
best_formula_fixed_only = "taxa_filt ~ 1"
current_fixed_effects = []

print("\n--- Iniciando Seleção Stepwise (Forward) para Efeitos Fixos ---")

# Inicializar com o modelo nulo para comparação
null_model_formula = "taxa_filt ~ 1"
null_model_aic = fit_and_get_aic(null_model_formula, dados_limpos, dados_limpos["id_elsa"])
if null_model_aic != np.inf:
    best_aic = null_model_aic
    print(f"AIC do Modelo Nulo: {best_aic:.2f}")

while True:
    added_variable = None
    min_aic_this_step = best_aic

    for candidate in fixed_effects_candidates:
        if candidate not in current_fixed_effects:
            temp_fixed_effects = current_fixed_effects + [candidate]
            temp_formula_fixed_only = "taxa_filt ~ " + " + ".join(temp_fixed_effects)
            
            aic = fit_and_get_aic(temp_formula_fixed_only, dados_limpos, dados_limpos["id_elsa"])
            
            if aic < min_aic_this_step:
                min_aic_this_step = aic
                added_variable = candidate

    if added_variable is not None and min_aic_this_step < best_aic:
        best_aic = min_aic_this_step
        current_fixed_effects.append(added_variable)
        best_formula_fixed_only = "taxa_filt ~ " + " + ".join(current_fixed_effects)
        print(f"Adicionado: {added_variable}, Novo AIC: {best_aic:.2f}")
    else:
        break

print(f"\n--- Seleção Stepwise Concluída ---")
print(f"Melhor Fórmula Encontrada (apenas efeitos fixos): {best_formula_fixed_only}")
print(f"Melhor AIC: {best_aic:.2f}")

# --- Ajustar o Modelo Final com a Melhor Fórmula Encontrada ---
print("\n--- Ajustando o Modelo Final ---")
model_final = smf.mixedlm(best_formula_fixed_only, dados_limpos, groups=dados_limpos["id_elsa"])
result_final = model_final.fit(reml=False) # Usar ML para AIC/BIC comparáveis

# Imprimir o resumo do modelo final
print(result_final.summary())

# --- Geração de Gráficos de Diagnóstico para o Modelo Final ---

# 1. Resíduos Padronizados vs. Valores Ajustados
plt.figure(figsize=(10, 6))
sns.residplot(x=result_final.fittedvalues, y=result_final.resid, lowess=True, line_kws={"color": "red", "lw": 1, "alpha": 0.8})
plt.xlabel("Valores Ajustados")
plt.ylabel("Resíduos Padronizados")
plt.title("Resíduos Padronizados vs. Valores Ajustados (Modelo Final)")
plt.grid(True)
plt.savefig("residuos_vs_ajustados_final.png")
plt.close()

# 2. Q-Q Plot dos Resíduos
import scipy.stats as stats
plt.figure(figsize=(8, 8))
stats.probplot(result_final.resid, dist="norm", plot=plt)
plt.title("Q-Q Plot dos Resíduos (Modelo Final)")
plt.xlabel("Quantis Teóricos")
plt.ylabel("Resíduos Padronizados")
plt.grid(True)
plt.savefig("qq_plot_residuos_final.png")
plt.close()

# 3. Histograma dos Resíduos
plt.figure(figsize=(10, 6))
sns.histplot(result_final.resid, kde=True)
plt.xlabel("Resíduos")
plt.ylabel("Frequência")
plt.title("Histograma dos Resíduos (Modelo Final)")
plt.grid(True)
plt.savefig("histograma_residuos_final.png")
plt.close()

# 4. Resíduos vs. Variáveis Preditores (Exemplo: hip e pas do modelo final)
# Selecionar as variáveis que estão no modelo final para os gráficos de resíduos
final_fixed_effects_for_plot = current_fixed_effects

if len(final_fixed_effects_for_plot) >= 2:
    plt.figure(figsize=(12, 6))

    plt.subplot(1, 2, 1)
    sns.scatterplot(x=dados_limpos[final_fixed_effects_for_plot[0]], y=result_final.resid, alpha=0.6)
    plt.xlabel(final_fixed_effects_for_plot[0])
    plt.ylabel("Resíduos")
    plt.title(f"Resíduos vs. {final_fixed_effects_for_plot[0]} (Modelo Final)")
    plt.grid(True)

    plt.subplot(1, 2, 2)
    sns.scatterplot(x=dados_limpos[final_fixed_effects_for_plot[1]], y=result_final.resid, alpha=0.6)
    plt.xlabel(final_fixed_effects_for_plot[1])
    plt.ylabel("Resíduos")
    plt.title(f"Resíduos vs. {final_fixed_effects_for_plot[1]} (Modelo Final)")
    plt.grid(True)

    plt.tight_layout()
    plt.savefig("residuos_vs_preditores_final.png")
    plt.close()
elif len(final_fixed_effects_for_plot) == 1:
    plt.figure(figsize=(6, 6))
    sns.scatterplot(x=dados_limpos[final_fixed_effects_for_plot[0]], y=result_final.resid, alpha=0.6)
    plt.xlabel(final_fixed_effects_for_plot[0])
    plt.ylabel("Resíduos")
    plt.title(f"Resíduos vs. {final_fixed_effects_for_plot[0]} (Modelo Final)")
    plt.grid(True)
    plt.tight_layout()
    plt.savefig("residuos_vs_preditores_final.png")
    plt.close()
else:
    print("Não há variáveis preditoras suficientes para gerar gráficos de resíduos vs. preditores.")

print("\nGráficos de diagnóstico para o modelo final gerados.")

# --- Geração de Gráficos de Correlação entre Variável Dependente e Independentes ---
print("\nGerando gráficos de correlação...")
for col in current_fixed_effects:
    plt.figure(figsize=(8, 6))
    sns.scatterplot(x=dados_limpos[col], y=dados_limpos["taxa_filt"], alpha=0.6)
    correlation = dados_limpos[col].corr(dados_limpos["taxa_filt"])
    plt.title(f"Taxa de Filtração vs. {col} (Correlação: {correlation:.2f})")
    plt.xlabel(col)
    plt.ylabel("Taxa de Filtração")
    plt.grid(True)
    plt.savefig(f"correlacao_{col}.png")
    plt.close()
print("Gráficos de correlação gerados.")


