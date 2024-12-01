from numpy import matrix, linalg, round

matriz_A = matrix([
    [7,2,4],
    [3,5,9],
    [1,6,8]
])

print(f"Matriz A: \n {matriz_A}")

### Criacao da matriz inversa de A
matriz_A_inv = linalg.inv(matriz_A)

print("\n")
print(f"A matriz inversa de A: \n {matriz_A_inv}")

### Produto da matriz_A e matriz_A_inv

matriz_B = round(matrix(matriz_A*matriz_A_inv, dtype='float'), decimals=1)
print(f"O produto da matriz_A e da matriz_A_inv e: \n {matriz_B}")