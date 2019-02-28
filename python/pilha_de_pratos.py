# -*- coding: utf-8 -*- 

prato=5
pilha=range(1, prato + 1)

while True:
    #print"\n"
    print"Existem %d pratos na pilha" %len(pilha)
    print"Pilha atual composta por: %s" %(pilha)
    #print"\n"
    print"-***************************************-"
    print"Digite:"
    print"E/e para epilhar um novo prato"
    print"D/d para desempilhar"
    print"S/s para sair"
    print"-***************************************-"
    operacao=str(raw_input())
    #print"\n"     

    if operacao=="D" or operacao=="d":
        if len(pilha)>0: 
            prato_lavado=pilha.pop(-1)
            print"O prato lavado foi: %d" %(prato_lavado)
        else:
            print"Nao ha mais pratos para serem lavados"   
         
    if operacao=="E" or operacao=="e":
        prato=prato+1
        pilha.append(prato)

    if operacao=="S" or operacao=="s":
        print"Saindo do programa"
        break

    if operacao!="S" and operacao!="s" and operacao!="E" and operacao!="e":
        print"Operacao invalida"

    print"\n" 
