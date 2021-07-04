#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 22 06:02:44 2021

@author: paulopimenta
"""

class leitura_dados_met:
    
    def __init__(self):
         self.varMET=" "
         self.tipo_nivel=" "
         self.level=" "
         self.dict_var_met={1: ["Surface pressure", "surface"],            
                            2: ["Temperature", "isobaricInhPa"]}
         
    def escolher_varMET(self):      
        print("==========================Variaveis Meteorologicas===========================")
        print("1: Surface pressure \
              \n2: Temperature")
        print("=============================================================================")    
        self.varMET=eval(input("Escolha uma variavel:"))
        print("Foi escolhido a variavel: " + self.dict_var_met[self.varMET][0])
    