from numpy import matrix, argsort

# Cria uma matriz A com valores inteiros (int)
matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9],
    [1, 6, 8]
])

print(f"matriz_A: \n {matriz_A}")

indice = matriz_A[:, 0].argsort(axis=0)
print(f"Os indices:\n {indice}")
# esta operacao faz a nova matriz receber os valores da matriz A com as linhas ordenadas
matriz_A_ordenada = matriz_A[indice, :]

# Matriz reordenada
print(f"A matriz_A reordenada e: \n {matriz_A_ordenada}")