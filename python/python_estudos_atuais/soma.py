#import entrada
from entrada import valida_inteiro

l = []
for x in range(5):
    #l.append(entrada.valida_inteiro("Digite um valor inteiro: ", 0, 10))
    l.append(valida_inteiro("Digite um valor inteiro: ", 0, 10))
print(f"Soma dos valores digitados: {sum(l)}")