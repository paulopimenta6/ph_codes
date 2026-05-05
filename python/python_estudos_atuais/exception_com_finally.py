nomes = ["Ana", "Carlos", "Maria"]
for tentativa in range(3):
    try:
        i = int(input("Digite o indice que quer imprimir: "))
        print(nomes[i])
    except Exception as e:
        print(f"Algo errado ocorreu: {e}")
    finally:
        print(f"Tentativa: {tentativa + 1}")