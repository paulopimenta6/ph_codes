import pandas as pd

# Carregar o CSV
df = pd.read_csv("dados.csv", sep=";", encoding="utf-8")

# Filtrar apenas vendas concluídas
df_completed = df[df["status"] == "Concluída"]

# Somar as vendas por vendedor
sales_by_seller = df_completed.groupby("vendedor")["valor_venda"].sum()

# Pegar os 3 vendedores com menor total de vendas
worst_3_sellers = sales_by_seller.nsmallest(3)

print(worst_3_sellers)
