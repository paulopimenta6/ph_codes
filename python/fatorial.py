# -*- coding: utf-8 -*-
"""
Created on Tue Aug 13 12:49:41 2024

@author: paulo.pimenta
"""

def fat(N):
    if N == 0:
        return 1
    else:
        return N*fat(N-1)
    
a = fat(4)
print(a)