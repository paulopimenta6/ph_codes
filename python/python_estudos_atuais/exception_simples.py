nomes = ["Ana", "Carlos", "Maria"]
for _ in range(3):
    try:
        i = int(input("Digite o indice que deseja acessar: "))
        print(nomes[i])
    except ValueError:
        print("Digite um numero inteiro")
    except IndexError:
        print("Valor invalido, digite um numero entre 0 e 2")