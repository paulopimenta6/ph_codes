from numpy import matrix, linalg 

# Codigo para calculo de autovalores e autovetores

matriz_A = matrix([
    [1, 0, 0],
    [0, 2, 0],
    [0, 0, 3]
])

print(f"Matriz A:\n{matriz_A}")

print("\n")

# Autovalores e autovetores da matriz A
### Autovalores
resultado = linalg.eig(matriz_A)
print(f"Os autovalores da matriz A sao: \n{resultado.eigenvalues}") #Poderia ser resultado[0]
print(f"Os autovetores da matriz A sao: \n{resultado.eigenvectors}") #Poderia ser resultado[1]