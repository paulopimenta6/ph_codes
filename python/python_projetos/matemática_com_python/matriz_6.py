from numpy import matrix

# Maior e menor elementos por linha e coluna
# Cria matriz A com valores inteiros (int)

matriz_A = matrix([
    [7,2,4],
    [3,5,9]
])

print(f"A matriz \"A\" de inteiros: \n {matriz_A}")

### Identifica o maior e o menor valor da matriz_A
maior_valor_A = matriz_A.max(axis = 0)
menor_valor_A = matriz_A.min(axis = 1)

print('\n')
print(f"Maior valor de cada coluna da matriz A: {maior_valor_A}")
print(f"Menor valor de cada linha da matriz A: {menor_valor_A}")