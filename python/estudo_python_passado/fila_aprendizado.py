# -*- coding: utf-8 -*- 

ultimo = 10
fila = range(1, ultimo + 1)
#print(fila)

while True:
    
    sair=False
    
    print"Existem %d clientes na fila" %(len(fila))
    print"Senhas da fila atual: %s" %(fila)
    
    print"\n"
    print"Digite:"
    print"F/f - para adicionar um cliente ao fim da fila" 
    print"A/a - para realizar um atendimento"
    print"S/s - para sair"
    operacao=str(raw_input()) 
    operacao=list(operacao)
    print"\n"
    
    while len(operacao)>0:
        operacao_no_momento=operacao.pop(0)	    

	if operacao_no_momento=="A" or operacao_no_momento=="a":
	    if (len(fila)>0):
                atendido=fila.pop(0)
                print"Cliente %d atendido" %atendido
            else:
                print"Fila vazia. Ninguem para atender"

        elif operacao_no_momento=="F" or operacao_no_momento=="f":
	    ultimo=ultimo+1 #incrementa adicionando um novo cliente
            fila.append(ultimo)	    

        elif operacao_no_momento=="S" or operacao_no_momento=="s":
            print"Saindo do programa"
            sair=True
            break 	   

        else:
            print"Operacao invalida"
            
    if(sair):
        print"Fila terminada finalizada com as senhas: %s" %(fila)
        break

print"Fim do programa!"	
