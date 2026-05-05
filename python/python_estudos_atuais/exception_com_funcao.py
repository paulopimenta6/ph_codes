def ehPar(n):
    try:
        return n%2 == 0
    finally:
        print("Executando antes de retornar")

try:
    print(2, " - ", ehPar(2))
    print("A", " - ", ehPar("A"))
except Exception as e:
    print(f"Algo errado aconteceu: {e}")    