#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 28 07:49:40 2021

@author: paulopimenta
"""

class teste_lista:
    def __init__(self):
        
        self.lst=[]
        
    def __len__(self):
        
        return len(self.lst) #Um metodo pode ser subscrito para atender a uma
    
    def adiciona_elento(self, elem):
        self.lst.append(elem)