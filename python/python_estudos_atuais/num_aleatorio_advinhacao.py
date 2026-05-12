from random import randint

n = randint(1, 100)

x = int(input("Escolha um numero entre 1 e 100: "))
if x == n:
    print("Parabens, voce acertou!")
else:
    print(f"Voce errou, o numero era {n}")