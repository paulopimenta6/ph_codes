#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

T=[-10, -8, 0, 1, 2, 5, -2, -4]

maximo=T[0]
minimo=T[0]
soma=0

for e in T:
	
	if e > maximo:
		maximo = e		
	
	elif e < minimo:
		minimo = e
			
 	soma = soma + e

print"Valor maximo: %d" %(maximo)
print"Valor minimo: %d" %(minimo)
print"Media: %.2f" %(soma/len(T))
