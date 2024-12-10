from numpy import matrix

# cria uma matriz de valores inteiros
matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9]
])
# Matriz A
print(f"Matriz A: \n {matriz_A}")

# Soma dos elementos da matriz_A por coluna
soma_colunas_A = matriz_A.sum(axis=0)
print(f"Soma dos elementos das colunas da matriz_A: \n{soma_colunas_A}")

# Soma dos elementos da matriz_A por linha
soma_linhas_A = matriz_A.sum(axis=1)
print(f"Soma dos elementos das linhas da matriz_A: \n{soma_linhas_A}")

# Soma de todos os elementos da matriz_A 
soma_matriz_A = matriz_A.sum()
print(f"Soma dos elementos da matriz_A: \n{soma_matriz_A}")