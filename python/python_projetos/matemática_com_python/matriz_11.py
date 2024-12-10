from numpy import matrix

matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9],
    [1, 6, 8]
])

print(f"Matriz A:\n{matriz_A}")

print("\n")

# Soma toda a matriz_A ao valor 4
matriz_B = matriz_A + 4
print(f"A nova matriz A somada ao valor 4:\n{matriz_B}")

# Subtracao de 1 pela matriz A 
matriz_C = 1 - matriz_A
print(f"A nova matriz C (1 - matriz_A):\n{matriz_C}")