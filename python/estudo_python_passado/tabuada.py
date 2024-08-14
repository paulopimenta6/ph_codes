#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Jan 21 00:40:19 2018

@author: paulo
"""

while True:
    n = int(input("Esta sera a tabuada de: [Digite um valor]:"))
    x=1
    
    while(x<=10):
        print(n*x)
        x+=1
        
    resposta=raw_input("Deseja continuar? s/S ou n/N ")
    if resposta == 'n' or resposta == 'N':
        break
    

