from numpy import matrix

matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9] 
])

print(f"matriz A: \n {matriz_A}")

print("\n")

# Identificar o maior e o menor valor da matriz A 
maior_valor_A = matriz_A.max()
menor_valor_A = matriz_A.min()

print(f"O maior valor da matriz: {maior_valor_A}\n. O menor valor da matriz: {menor_valor_A}")