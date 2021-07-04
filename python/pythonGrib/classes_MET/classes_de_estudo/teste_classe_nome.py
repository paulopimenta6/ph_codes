#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 23 00:54:03 2021

@author: paulopimenta
"""
from teste_classe_lista_nome import cria_lista_nome

class nome_sobrenome:
    
    def __init__(self, nome, sobrenome):
        self.nome=nome
        self.sobrenome=sobrenome
        self.lst_nome_completo=[]     
    
    def cria_lista_nome_sobrenome(self):
        self.lst_nome_completo.append(self.nome) 
        self.lst_nome_completo.append(self.sobrenome)        
        
    def imprime_nome(self):
        self.cria_lista_nome_sobrenome()
        cria_lista_nome(self.lst_nome_completo).imprime_lista_nome_sobrenome()
       
    def limpa_nomes(self):
        self.nome=" "
        self.sobrenome=" "
        self.lst_nome_completo=[]     