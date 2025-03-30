import pandas as pd

# Carregar o CSV
df = pd.read_csv("dados.csv", sep=";", encoding="utf-8")

# Converter a coluna de data para formato datetime
df["data_venda"] = pd.to_datetime(df["data_venda"], format="%d/%m/%Y")

# Somar as vendas por ano
vendas_por_ano = df.groupby(df["data_venda"].dt.year)["valor_venda"].sum()

# Encontrar o ano com o valor específico
ano_desejado = vendas_por_ano[vendas_por_ano == 3689379.28]

# Exibir o resultado
if not ano_desejado.empty:
    print(f"O total de R$ 3.689.379,28 em vendas ocorreu no(s) ano(s): {ano_desejado.index.tolist()}")
else:
    print("Nenhum ano teve exatamente R$ 3.689.379,28 em vendas.")

import pandas as pd

# Carregar o CSV
df = pd.read_csv("dados.csv", sep=";", encoding="utf-8")

# Converter a coluna de data para formato datetime
df["data_venda"] = pd.to_datetime(df["data_venda"], format="%d/%m/%Y")

# Somar as vendas por ano
vendas_por_ano = df.groupby(df["data_venda"].dt.year)["valor_venda"].sum()

# Definir o valor desejado
valor_desejado = 3689379.28

# Calcular a diferença absoluta entre o valor desejado e as vendas de cada ano
diferenca = (vendas_por_ano - valor_desejado).abs()

# Encontrar o ano com a menor diferença
ano_proximo = diferenca.idxmin()

# Exibir o resultado
print(f"O ano com o total de vendas mais próximo de R$ {valor_desejado:,.2f} foi {ano_proximo}, com R$ {vendas_por_ano[ano_proximo]:,.2f} em vendas.")
