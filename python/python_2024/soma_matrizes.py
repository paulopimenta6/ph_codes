# -*- coding: utf-8 -*-
"""
Created on Tue Aug 13 12:03:13 2024

@author: paulo.pimenta
"""

t = [[4,7,5,2], [5,1,9,2]]
s = [[0,1,9,2], [0,1,1,1]]

def soma2D(t,s):
    nlin = len(t)
    ncol = len(t[0])
    
    w = []    
    for i in range(nlin):
        z = []
        for j in range(ncol):
            z.append((t[i][j] + s[i][j]))
        w.append(z)    
            
            
    return w

print(soma2D(t, s))        
    