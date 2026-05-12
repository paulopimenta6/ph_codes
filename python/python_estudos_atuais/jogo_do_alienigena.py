import random

MAX_TENTATIVAS = 3
arvore = random.randint(1, 100)

print("Bem vindo ao jogo do alienigena!")
print("Um alienigena esta escondido atras de uma arvore")
print("Cada arvore foi numerada de 1 a 100")
print("Voc tem 3 tentativas para advinha em que arvore ele esta escondido")
print("O alienigena se esconde!")
print(arvore)

for tentativa in range(1, MAX_TENTATIVAS + 1):
    palpite = int(input(f"Arvore {tentativa}/{MAX_TENTATIVAS}: "))
    if palpite == arvore:
        print(f"Parabens, voce acertou na {tentativa}\u00AA tentativa")
        break
    elif palpite > arvore:
        print("Muito alto!")
    else:
        print("Muito baixo!")
else:
    print(f"Voce nao conseguiu acertar.")
    print(f"O alienigena estava escondido atras da arvore {arvore}")




