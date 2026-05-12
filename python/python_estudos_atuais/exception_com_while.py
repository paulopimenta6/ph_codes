while True:
    try:
        v = int(input("Digite um valor inteiro (0 sai): "))
        if v == 0:
            break
    except Exception:
        print("Valor invalido")
    else:
        print("Parabens, nenhuma excecao foi gerada e o valor digitado foi: ", v)
    finally:
        print("Executado sempre, mesmo com break")