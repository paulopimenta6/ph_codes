# -*- coding: utf-8 -*-

a=[1,2,3,4,5,6]
b=[7,8,9,10,11,12]
i=0
l=[]

if len(a) == len(b):
    print"Vetores com tamanhos iguais"
    while i < len(b):
        c = a[i] + b[i]
        print(c)
        l.append(c)
        i = i + 1

print(l)    
