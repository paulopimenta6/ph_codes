import numpy as np

def __init__(self, capacidade):
    self.capacidade = capacidade
    self.ultima_posicao = -1
    self.valores = np.empty(self.capacidade, dtype=int)

# O(n)
def imprime(self):
    if self.ultima_posicao == -1:
        print("O vetor esta vazio")
    else:
        for i in range(self.ultima_posicao + 1):
            print(i, " - ", self.valores[i])

# O(n)
def insere(self, valor):
    if self.ultima_posicao == self.capacidade - 1:
        print("Capacidade maxima atingida")
        return

    posicao = 0
    for i in range(self.ultima_posicao + 1):
        posicao = i
        if self.valores[i] > valor:
            break
        if i == self.ultima_posicao:
                 