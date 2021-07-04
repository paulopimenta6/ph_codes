#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 23 00:56:25 2021

@author: paulopimenta
"""

class cria_lista_nome:
    
    def __init__(self, lista_nomes): 
        self.lista_nomes=lista_nomes
        
    def imprime_lista_nome_sobrenome(self):
        for c in self.lista_nomes:
            print(c)