def raiz_quadrada(x):
    b=x
    diferenca=1
    while abs(diferenca) > 0.0000000001:
        p = (0.5)*(b + (x/b))
        diferenca=(p-b)         
        b=p
    print(p)
    #return p

print("++++++++++++++++++++++++++++++++++++")
print("Programa que calcula a raiz quadrada")
print("++++++++++++++++++++++++++++++++++++")
print("Digite um valor: ")
var=float(raw_input())
raiz_quadrada(var)
