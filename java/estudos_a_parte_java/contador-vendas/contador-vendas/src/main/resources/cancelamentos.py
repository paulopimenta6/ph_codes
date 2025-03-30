import pandas as pd

# Carregar o CSV
df = pd.read_csv("dados.csv", sep=";", encoding="utf-8")

# Filtrar apenas vendas canceladas
df_completed = df[df["status"] == "Cancelada"]

# Contar as vendas canceladas por vendedor
cancelamentos_por_vendedor = df_completed.groupby("gestor").size()

# Pegar os 3 vendedores com maior número de cancelamentos
top_3_sellers = cancelamentos_por_vendedor.nlargest(3)

print(top_3_sellers)
