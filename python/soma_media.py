#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Jun 24 21:58:26 2018

@author: paulopimenta
"""
print "Programa que termina quando 0 - zero e digitado"
lista = []
soma = 0

while True:
    print "Digite um valor: "
    valor = int(raw_input())
    if valor == 0:
        break
    else:
        soma = soma + valor
        lista.append(valor)

media_aritmetica = soma/len(lista)

print "A lista de numero e: %s" %(lista)
print "A soma dos numeros e: %d" %(soma)
print "A media artimetica e: %.2f" %(media_aritmetica)