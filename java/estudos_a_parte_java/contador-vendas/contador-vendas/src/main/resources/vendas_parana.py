import pandas as pd

# Carregar o CSV
df = pd.read_csv("dados.csv", sep=";", encoding="utf-8")

# Converter a coluna de data para o formato correto
df["data_venda"] = pd.to_datetime(df["data_venda"], format="%d/%m/%Y")

# Aplicar os filtros:
df_filtered = df[
    (df["status"] == "Concluída") &  # Somente vendas completas
    (df["uf"] == "PR") &  # Somente vendas no Paraná
    (df["data_venda"].dt.month.isin([1, 6, 12]))  # Somente vendas em janeiro, junho e dezembro
]

# Calcular o total de vendas
total_vendas = df_filtered["valor_venda"].sum()

print(f"Total de vendas filtradas: R$ {total_vendas:.2f}")
