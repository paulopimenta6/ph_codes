#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 20 21:45:59 2018

@author: paulo
"""

while True:

    categoria = int(input("Digite a categoria do produto: "))
       
    if categoria == 1:
        
        preco = 10
        
    elif categoria == 2:
        
        preco = 18
    
    elif categoria == 3:
        
        preco = 23
    
    elif categoria == 4:
        
        preco = 26
    
    elif categoria == 5:
        
        preco = 31
    
    else:
    
        print("Categoria invalida, digite um valor entre 1 e 5!")
        preco = 0
    
    print("O preco do produto: R$%5.2f" %preco)
    
    resposta = raw_input("Deseja continuar?: s/S ou n/N ")
    if resposta == 'n' or resposta == 'N':
        break
        
       
        