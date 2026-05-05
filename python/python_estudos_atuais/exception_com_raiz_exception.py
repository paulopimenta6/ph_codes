nomes = ["Ana", "Carlos", "Maria"]

for _ in range(3):
    try:
        i = int(input("Digite o indice que quer imprimir: "))
        print(nomes[i])
    except Exception as e:
        print(f"Algo de errado aconteceu: {e}")
