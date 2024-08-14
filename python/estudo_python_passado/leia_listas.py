L1 = []
L2 = []
L3_SOMA = []
L3_SUBTRACAO = []

print "Programa que le duas listas!"
print "Vamos trabalhar com a lista 1"
print "As listas so aceitam numeros, qualquer coisa diferente o preenchimento e encerrado"

print "----Lista 1----"
while True:
    print "Digite um valor para a lista 1. Lembre-se que so pode ser valor numerico!"
    valor1 = int(raw_input())
    
    if valor1 == 0:
        break
    else:
        L1.append(valor1)
        
    print "Digite um valor para a lista 2. Lembre-se que so pode ser valor numerico!"
    valor2 = int(raw_input())
    
    if type(valor2) == 0:
        break
    else:
        L2.append(valor2)
        
if len(L1) == len(L2):
    L3 = L1 + L2
    
    for i in range(len(L1)):
        L3_SOMA.append(L1[i] + L2[i])
        
    for i in range(len(L1)):
        L3_SUBTRACAO.append(L1[i] - L2[i])
     
    print(L1)
    print(L2)
    print(L3_SOMA)
    print(L3_SUBTRACAO)    
        
else:
    print "Tamanhos diferentes!!"
    print(L1)
    print(L2)
 
           
        
            
