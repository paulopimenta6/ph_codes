from numpy import matrix

matriz_A = matrix([
    [1,2,3],
    [4,5,6]
])

matriz_B = matrix([
    [1.0, 2.2, 3.1],
    [4.6, 5.4, 6.7]
])

print('Matriz A: ')
print(matriz_A)

print('\n')

print('Matriz B: ' )
print(matriz_B)

print('\n')

print("Dimensoes da matriz A")
dimensoes_matriz_A = matriz_A.shape
print(dimensoes_matriz_A)

print("Dimensoes da matriz B")
dimensoes_matriz_B = matriz_B.shape
print(dimensoes_matriz_B)

print("\n")
print("O elemento da primeira linha e segunda coluna da matriz B e: ")
elemento_B_L0_C1 = matriz_B[0,1]
print(elemento_B_L0_C1)