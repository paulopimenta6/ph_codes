#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 17 02:22:55 2018

@author: paulo
"""

contador = 0
lista = []
lista.append("a")
lista.append("b")
lista.append("c")
lista.append("d")
vetor_teste_1 = ["Joao", "Carlos", "Pedro", "Jose"]
vetor_teste_2 = ["Maria", "Larissa", "Elena", "Marina"] 

for i in range(len(lista)):

    if i==0:
        for j in range(len(vetor_teste_1)):
             print(vetor_teste_1[j])

    if i==1:
        for j in range(len(vetor_teste_2)):
             print(vetor_teste_2[j])
             