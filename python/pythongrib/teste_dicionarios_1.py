#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 12 23:58:57 2021

@author: phpimenta
"""

compras = {
            'frutas_joao': {
            'pera': 50, 
            'uva': 2, 
            'maçã':55, 
            'abacaxi': 25,
            },
           'frutas_maria': {
            'pera': 40, 
            'uva': 3, 
            'maçã':35, 
            'abacaxi': 15,
            },}
for tipo, tipo2 in compras.items():
    print('\nTipo do item: '+ tipo)
    tudo_qtd = 'pera: '+str(tipo2['pera']) + " "
    tudo_qtd += 'uva: '+str(tipo2['uva']) + " "
    tudo_qtd += 'maçã: '+str(tipo2['maçã']) + " "
    tudo_qtd += 'abacaxi: '+str(tipo2['abacaxi'])
    
    print('Quantidade de itens comprados: '+tudo_qtd.title())