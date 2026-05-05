nomes = ["Ana", "Carlos", "Maria"]
try:
    i = int(input("Digite o indice que quer imprimir: "))
    print(nomes[i])
except ValueError:
    print("Digite um numero inteiro")
    raise #Raise a exceção para frente, apos tratar o erro.
finally:
    print("Sempre o finally é executado")