from numpy import matrix, empty, array
matriz_A = matrix([
  [7, 2, 4],
  [3, 5, 9],
  [1, 6, 9]  
])

print(f"Matriz A:\n{matriz_A}")

# Multiplica a matriz A por 3
matriz_B = matriz_A*3
print(f"O valor da matriz A multiplicada por 3:\n{matriz_B}")
# Multiplica a matriz A por 1/2, ou seja, divide a matriz por 2
matriz_C = matrix(matriz_A/2, dtype='int')
print(f"O valor da matriz A multiplicada por 1/2:\n{matriz_C}")
# Multiplica a matriz A por 1.0/2.0, ou seja, divide a matriz por 2.0 - um float
matriz_D = matriz_A/2.0
print(f"O valor da matriz A multiplicada por 1.0/2.0 (float):\n{matriz_D}")


########################################
### Extra de conhecimento
matriz_teste = empty((2,4), dtype='int')
print(matriz_teste)
print(matriz_teste.shape)
values = array([1,2,3,4,5,6,7,8])
print(values)
matriz_teste = values.reshape(2,4)
print(matriz_teste)
########################################