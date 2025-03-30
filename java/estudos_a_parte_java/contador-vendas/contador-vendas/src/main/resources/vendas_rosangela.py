import pandas as pd

# Carregar o CSV
df = pd.read_csv("dados.csv", sep=";", encoding="utf-8")

# Converter a coluna de data para formato datetime
df["data_venda"] = pd.to_datetime(df["data_venda"], format="%d/%m/%Y")

# Definir intervalo de datas
inicio = "2012-05-12"
fim = "2012-07-29"

# Filtrar as vendas da vendedora Rosângela Almeida no período
df_filtered = df[
    (df["vendedor"] == "Rosângela Almeida") &
    (df["data_venda"] >= inicio) &
    (df["data_venda"] <= fim)
]

# Contar o número de vendas
total_vendas = df_filtered.shape[0]

print(f"Rosângela Almeida realizou {total_vendas} vendas no período.")
