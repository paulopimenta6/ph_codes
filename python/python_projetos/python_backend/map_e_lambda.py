# -*- coding: utf-8 -*-
"""
Editor Spyder

Este é um arquivo de script temporário.
"""

def map_1(funcao, valores):
    retorno = []
    for v in valores:
        retorno.append(funcao(v))
        
    return retorno    
        
list_a = map_1(lambda x: x/2, [1,2,3])
print(list_a)

list_b = list(map(lambda x: x/2, [1,2,3]))
print(list_b)    


list_c = list(map(lambda a,b: a+b, [1,2,3], [4,5,6]))
print(list_c)

list_d = list(map(lambda a,b: (a,b), [1,2,3], [4,5,6]))
print(list_d)


