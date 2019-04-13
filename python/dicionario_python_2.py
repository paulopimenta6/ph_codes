#!/usr/bin/env python2
#-*- coding:utf-8 -*-

################################################################
#Programa para gerar um dicionario                            ##
#Autor: Paulo Pimenta                                         ##
#contato: paulopimenta6@gmail.com                             ##
#..       paulopimenta315@gmail.com                           ##
#Versao 1.0 - 01/04/2019                                      ##
#Versao 2.0 - 01/04/2019 algumas minutos depois               ##
################################################################

estoque={ "tomate": [ 1000, 2.30],
          "alface": [   500, 0.45],
          "batata": [ 2001, 1.20],
          "feijao": [   100, 1.50] }

for prateleira_produto, prateleira_qtd_prec in estoque.items():
    print"Descricao >>",  prateleira_produto
    print"Quantidade >>", prateleira_qtd_prec[0]
    print"Preco >>", prateleira_qtd_prec[1]
    print" "

total = 0

print"Vendas: \n"

while True:
     produto = raw_input("Nome do produto (fim para sair):")
     if produto == "fim":
        break
     if produto in estoque:
        quantidade = int(raw_input("Quantidade:"))
        if quantidade <= estoque[produto][0]:
            preco = estoque[produto][1]
            custo = preco * quantidade
            print"O produto: " + produto + ", a quantidade: " + quantidade + ", o preco: " + " e o custo: " + custo            
            estoque[produto][0] -= quantidade
            total += custo
        else:
            print("Quantidade solicitada não disponível")
     else:
        print("Nome de produto invalido")
print(" Custo total: %21.2f\n" % total)
print("Estoque:\n")
for chave, dados in estoque.items():
     print("Descricao: ", chave)
     print("Quantidade: ", dados[0])
     print("Preco: %6.2f\n" % dados[1])
