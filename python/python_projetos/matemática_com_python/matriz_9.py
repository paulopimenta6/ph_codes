from numpy import matrix, linalg

matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9],
    [1, 6, 8] 
])

print(f"Matriz A: \n {matriz_A}")

# Determinante da matriz A
determinante = linalg.det(matriz_A)

print("\n")
print(f"Determinante da matriz A: {determinante}")