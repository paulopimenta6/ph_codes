from numpy import matrix, power

matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9],
    [1, 6, 8]
])

print(f"Matriz A:\n{matriz_A}")

# Eleva todos os elementos da matriz A ao cubo
matriz_B = power(matriz_A, 3)
print(f"Todos os elementos da matriz A foram elevados ao cubo (^3)")
print(f"A matriz elevada ao cubo: \n{matriz_B}")