# Solucao de sistemas lineares de 3 equacoes

from numpy import matrix, linalg
matriz_A = matrix([
    [3, -1, 1],
    [-2, 3, -3],
    [-1, -3, -4]
])

matriz_B = matrix([
    [11],
    [-19],
    [-15]
])

matriz_A_inv = linalg.inv(matriz_A)
solucao_SL = matriz_A_inv*matriz_B

print(f"AX = B")
print(f"matriz A:\n{matriz_A}")
print(f"X:\n{solucao_SL}")
print(f"matriz B:\n{matriz_B}")