#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul  3 10:16:27 2021

@author: paulopimenta
"""

class parse_param:
    
    def __init__(self, param):
        #self.param=param.split(" ")
        self.param=param[1:]
        self.varMET=" "
        self.varNivel=" "
        self.varRegiao=" "
        
    def imprime_parse(self):    
        
        if len(self.param)>1:
            if self.param[0]=="-v" or self.param[0]=="--variavel":
                self.varMET=self.param[1]
                if self.param[2]=="-n" or self.param[2]=="--nivel":
                    self.varNivel=int(self.param[3])
                    if self.param[4]=="-r" or self.param[4]=="--regiao":
                        self.varRegiao=self.param[5]
                    elif self.param[4]=="-ll" or self.param[4]=="--latlon":
                        self.varRegiao=self.param[5],self.param[6]
                    else:
                        self.varRegiao=-1
                        print("Variavel Regiao vazia")
                else:
                    self.varNivel=1
                    print("Variavel Nivel vazia")
            else:
                self.varMET=-1
                print("Variavel MET vazia")
        else:
            print("Sem parametros")                     
     
        if self.varMET!=-1 and self.varNivel!=-1 and self.varRegiao!=-1:
            return self.varMET, self.varNivel, self.varRegiao