#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 20 20:59:04 2018

@author: paulo
"""

print("Este e um programa que converte de Metros para...")
print("... milimetros \n")

num1 = float(input("Digite uma medida em [metros]: "))

num3 = (num1*1000.00)

if num1 > 1000:

    print("%5.2f em metros convertido em militeros e: %5.2f " %(num1, num3))
    print("O valor de %5.2f e maior que 1000" %num1)
    
else:

    print("%5.2f em metros convertido em militeros e: %5.2f " %(num1, num3))
    print("O valor de %5.2f e menor que 1000" %num1)    