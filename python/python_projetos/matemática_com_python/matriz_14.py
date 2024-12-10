from numpy import matrix, multiply

matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9]
])

matriz_B = matrix([
    [3, 6, 9],
    [1, 8, 2]
])

print(f"A matriz A:\n{matriz_A}")
print(f"A matriz B:\n{matriz_B}")

# Produto de elemento por elemento da matriz A pela matriz B
matriz_C = multiply(matriz_A, matriz_B)
print(f"A matriz com produto elemento por elemento e:\n{matriz_C}")