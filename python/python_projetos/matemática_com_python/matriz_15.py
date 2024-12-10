from numpy import matrix, round

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

# A divisao da matriz A pela matriz B elemento a elemento
#matriz_C = round(matrix(matriz_A/matriz_B, dtype = 'float'), decimals=2) 
matriz_C = round(matriz_A/matriz_B, decimals=2) #Pode ser resumido também a funcao round
print(f"O resultado da divisão membro a membro da matriz A pela matriz B e:\n{matriz_C}")