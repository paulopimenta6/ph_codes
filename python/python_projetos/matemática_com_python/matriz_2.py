from numpy import zeros, ones, identity

# matriz de zeros
matriz_C = zeros((4,3), dtype='int')

print("Uma matriz de zeros: ")
print(matriz_C)

print("\n")

# matriz com valores em ponto flutuante
matriz_D = ones((2,3), dtype = 'float')
print(matriz_D)

print("\n")

# Produto de uma matriz de uns por 5
matriz_E = 5*ones((4,2), dtype='float')
print(matriz_E)

print('\n')

# matriz identidade 3x3
matriz_F = identity(3)
print(matriz_F)