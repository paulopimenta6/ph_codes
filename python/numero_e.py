# -*- coding: utf-8 -*-
"""
Created on Tue Aug 13 14:37:51 2024

@author: paulo.pimenta
"""

def fat(N):
    if N == 0:
        return 1
    else:
        return N*fat(N-1)
    
def calcular_e(erro_max):
    n = 0
    soma_anterior = 0 
    soma_atual = 1.0
    
    while abs(soma_atual-soma_anterior) > erro_max:
        n += 1
        soma_anterior = soma_atual
        termo = 1.0/fat(n)
        
        soma_atual += termo
        print("e (" + str(n) + "):" + str(soma_atual))
        
    return soma_atual

e1 = calcular_e(0.01)
print(e1)    