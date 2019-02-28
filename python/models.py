# -*-coding: utf-8 -*-

class Perfil(object):
    "Classe para moldar perfis de usuarios"
    def __init__(self, nome, telefone, empresa):
        self.nome=nome
        self.telefone=telefone
        self.empresa=empresa
        self.__curtidas=0

    def curtir(self):
         self.__curtidas+=1

    def obter_curtidas(self):
         return self.__curtidas

    def imprimir(self):
        print"Nome: %s, Telefone: %s, Curtidas: %d e Empresa: %s" %(self.nome, self.telefone, self.__curtidas, self.empresa)
