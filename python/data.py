# -*- coding: utf-8 -*-

class data(object):
    "imprimi uma data de forma livre"
    def __init__(self, dia, mes, ano):
        self.dia=dia
        self.mes=mes
        self.ano=ano
    def imprimir(self):
        print"A data e: %s/%s/%s" %(self.dia, self.mes, self.ano)
