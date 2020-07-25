
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 25 00:43:25 2018

@author: paulopimenta
"""

print "+++++++++++++++++++++++++++++++++++++++++++++++++++"
print "Super Mercado Total"
print "Sistema de auto atendimento"
print "Digite o codigo e a quantidade do item"
print "A escolha do 0 acarreta na saida do programa"
print "A escolha da operacao e valor 0 acarreta na saida do programa"
print "+++++++++++++++++++++++++++++++++++++++++++++++++++"

print "###################################################"
print " Produto 1 - R$0.50"
print " Produto 2 - R$1.00"
print " Produto 3 - R$4.00"
print " Produto 5 - R$7.00"
print " Produto 9 - R$8.00"
print "###################################################"

lista_de_produto = []
qtd_1 = qtd_2 = qtd_3 = qtd_5 = qtd_9 = 0 #Como ninguem comprou comeca com 0
preco_1 = preco_2 = preco_3 = preco_5 = preco_9 = 0 #Como ninguem comprou comeca com 0

lista_de_produtos={"Produto 1":qtd_1, "Produto 2":qtd_2, "Produto 3":qtd_3, "Produto 5":qtd_5, "Produto 9":qtd_9}

while True:
    print "Deseja continuar? [s/S] ou [n/N]: "
    continuar = str(raw_input())    
    if continuar != 's' and continuar != 'S':
        print "Saindo do caixa"        
        break  
    
    else:
        while True:           
            print "Digite o codigo do produto: "
            produto = str(raw_input())
            
            if produto == '1':
                print "Qual quantidade do produto: "
                qtd_1 = int(raw_input())
                preco_1 = qtd_1*(0.50)
    
            elif produto == '2':
                print "Qual quantidade do produto: "
                qtd_2 = int(raw_input())
                preco_2 = qtd_2*(1.00)
    
            elif produto == '3':
                print "Qual quantidade do produto: "
                qtd_3 = int(raw_input())
                preco_3 = qtd_3*(4.00)
                
            elif produto == '5':
                print "Qual quantidade do produto: "
                qtd_5 = int(raw_input())
                preco_5 = qtd_5*(7.00)
                
            elif produto == '9':
                print "Qual quantidade do produto: "
                qtd_9 = int(raw_input())
                preco_9 = qtd_9*(8.00)           
                
            elif produto == '0':
                soma= preco_1 + preco_2 + preco_3 + preco_5 + preco_9
                print "O total de cada item e: %s" %(lista_de_produtos)
                print "O total a ser pago: %.2f" %(soma)                        
                break
                
            else:
                print "Operacao nao valida"
                break

            
            
            
            