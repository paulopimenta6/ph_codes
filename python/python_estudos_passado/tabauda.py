#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Jun 24 23:04:18 2018

@author: paulopimenta
"""
print "+++++++++++++++++++++++++++++++++++++++++++++++++++"
print "Caluladora e tabuada"
print "Escolha uma operacao: + - / *"
print "A escolha do 0 acarreta na saida do programa"
print "A escolha da operacao e valor 0 acarreta na saida do programa"
print "Lembrando que 0 e um elemento neutro."   
print "+++++++++++++++++++++++++++++++++++++++++++++++++++"

while True:
    print "Digite um valor: "
    valor = int(raw_input())
    if valor == 0:
        print "Saindo do programa"
        break
    
    else:
        print "Escolha uma operacao: "
        operacao = str(raw_input())
        
        if operacao == '+':
            contador = 1
            lista = []
            while contador <= 10:            
                resultado = valor + contador
                lista.append(resultado)
                contador = contador + 1
         
            print "A tabuda de %s do numero %s e :" %(operacao, lista)            
    
        elif operacao == '-':
            contador = 1
            lista = []
            while contador <= 10:            
                resultado = valor - contador
                lista.append(resultado)
                contador = contador + 1
         
            print "A tabuda de %s do numero %s e :" %(operacao, lista)                  
     
        elif operacao == '*':
            contador = 1
            lista = []
            while contador <= 10:            
                resultado = valor * contador
                lista.append(resultado)
                contador = contador + 1
         
            print "A tabuda de %s do numero %s e :" %(operacao, lista)            
    
        elif operacao == '/':
            contador = 1
            lista = []
            while contador <= 10:            
                resultado = valor/contador
                lista.append(resultado)
                contador = contador + 1
         
            print "A tabuda de %s do numero %s e :" %(operacao, lista)            
         
        elif operacao == '0':
            print "Saindo do programa"
            break
         
        else:
            print "Operacao nao valida"
            print "Digite um valor e operacao!"



          