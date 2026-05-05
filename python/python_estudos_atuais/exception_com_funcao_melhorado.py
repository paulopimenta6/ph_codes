def ehPar(n):
    try:
        return n % 2
    except Exception:
        raise ValueError("Valor invalido") #from None

print(ehPar(2))
print(ehPar([]))