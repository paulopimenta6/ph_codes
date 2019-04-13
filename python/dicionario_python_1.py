#!/usr/bin/env python2
#-*- coding:utf-8 -*-

#############################################
#Programa para gerar um dicionario         ##
#Autor: Paulo Pimenta                      ##
#contato: paulopimenta6@gmail.com          ##
#..       paulopimenta315@gmail.com        ##
#############################################

frase = raw_input("Digite uma frase para contar as letras:")
d = {}
for letra in frase:
   if letra in d:
       d[letra]=d[letra]+1
   else:
       d[letra]=1
print(d)
