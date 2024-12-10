from numpy import matrix

matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9]
])

matriz_B = matrix([
    [3, 6, 9],
    [1, 8, 2]
])

print(f"A matriz A e:\n{matriz_A}")
print(f"A matriz B e:\n{matriz_B}")

# Somando duas matrizes
matriz_C = matriz_A + matriz_B

print(f"A soma da matriz A com a matriz B e:\n{matriz_C}")