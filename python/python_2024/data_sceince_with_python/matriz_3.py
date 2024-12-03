from numpy import matrix, transpose

matriz_A = matrix([
    [7,2,4],
    [3,5,9]
])

print(f"Matriz A: \n {matriz_A}")

matriz_A_t = transpose(matriz_A)

print(f"Matriz transposta de A: \n {matriz_A_t}")