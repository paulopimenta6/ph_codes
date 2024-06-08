#!/usr/bin/env python2
#-*- coding:utf-8 -*-

while True:
    var_1=int(raw_input("Digite um numero: "))
    var_2=int(raw_input("Digite um segundo numero: "))

    soma = var_1 + var_2
    print("O valor da soma e: " + str(soma))

    var_3=(raw_input("Deseja continuar? s/S ou n/N"))
    if var_3=="n" or var_3=="N":
        break
