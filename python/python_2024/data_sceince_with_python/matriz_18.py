# Solucao de sistemas lineares de 2 equacoes

from numpy import matrix, linalg

matriz_A = matrix([
    [2, -5],
    [3, 6]
])

matriz_B = matrix([
    [11],
    [3]
])

print(f"")
print(f"Matriz A:\n{matriz_A}")
print(f"Matriz B:\n{matriz_B}")

# Lembrando que todo conjunto de equações lineares é da forma AX = B, em que A é a matriz de valores, 
# X a matriz de incognitas (o qual sera abstraida) e B e a matriz resposta
# Lembrando que se AX = B, logo se multiplicarmos pelos dois lados pela inversa de A, ou seja, A^(-1), entao:
# (A^(-1))*A*X = (A^(-1))*B .:. I*X = (A^(-1))*B .:. X = (A^(-1))*B
 
# Cria a matriz inversa de A
matriz_A_inv = linalg.inv(matriz_A)

# X = (A^(-1))*B
solucao_SL = matriz_A_inv*matriz_B

print("--------------------------------------------------------------------")
print(f"AX = B")
print(f"A = {matriz_A}\n")
print(f"X = {solucao_SL}\n")
print(f"B = {matriz_B}\n")