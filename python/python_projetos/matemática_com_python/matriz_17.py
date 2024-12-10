from numpy import matrix

matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9]
])

matriz_B = matrix([
    [3, 9],
    [5, 8],
    [7, 6]
])

print(f"A matriz_A e:\n{matriz_A}")
print(f"A matriz_B e:\n{matriz_B}")

# Produto de uma matriz por outra matriz
matriz_C = matriz_A*matriz_B

print(f"A matriz_C = matriz_A*matriz_B e:\n{matriz_C}")