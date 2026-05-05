# -*- coding:utf-8 -*-

class imc(object):
    "classe que calcula o imc"
    def __init__(self,nome, peso, altura):
        self.nome=nome
        self.peso=peso
        self.altura=altura
    def calcula_imc(self):
        imc=(self.peso)/((self.altura)**2)
        print"O imc de %s e: %.3f" %(self.nome, imc)
