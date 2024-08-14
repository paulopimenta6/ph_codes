# -*- coding: utf-8 -*-

cont=0
ultimo = 10
fila = list(range(1,ultimo+1))

while True:      

     print"+++++++++++++++++++++++++++++++"

     print"Bem-vindo ao Banco" 

     print"+++++++++++++++++++++++++++++++"

     print"Existem %d clientes na fila" %(len(fila))
     print"Fila atual: %s" %(fila)
         
     print"Digite \"F\" para adicionar um cliente ao fim da fila"
     print"Digite \"A\" para o cliente ser atendido"
     print"A digitacao pode ser de uma cadeia de opcoes:"
     operacao = str(raw_input())     

     while cont < len(operacao):
     
	     if operacao[cont] == "A":
		 
		 if(len(fila))>0:
		       atendido = fila.pop(0)
		       print"Cliente senha n° %d atendido" %(atendido)
		 else:
		       print("Fila vazia! Ninguém para atender.")
	     
	     elif operacao[cont] == "F":
		 ultimo = ultimo + 1 # Increnta o ticket do novo cliente
		 fila.append(ultimo)
                 print"Cliente adicionado ao final da fila de senha senha n° %d" %(ultimo)
                 print(fila) 
	     	      
	     else:
		 print("Operação inválida! Digite apenas \"F\" ou \"A\"" )

             cont = cont + 1


     print"Deseja continuar? [s/S ou n/N]"
     ans = str(raw_input())
     if ans == "n" or ans == "N":
	break	







  
