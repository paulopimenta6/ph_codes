#!/usr/bin/env python2
#-*- coding:utf-8 -*-

primeira=str(raw_input("Digite a primeira string: "))
segunda=str(raw_input("Digite a segunda string: "))
terceira=""

for letra in primeira:
    if letra in segunda and letra not in terceira:
        terceira=terceira+letra
    
if len(terceira)>0:
    print(terceira)
    print(len(terceira))
else:
    print("Nao ha nada em comum entre ambas as strings")
