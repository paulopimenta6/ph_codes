#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 25 09:50:17 2021

@author: paulopimenta
"""

class regioes_predefinidas:
    def __init__(self, regiao):
        
        self.regiao=regiao
        self.lst=[]
        self.lons=" "
        self.lats=" "

# =============================================================================
# Mais regioes devem ser incluidas nesta classe tais como:
# Fortaleza, Recife, Salvador, Belem, Belo Horizonte, Curitiba e Porto Alegre
# =============================================================================

        #self.regiao=regiao
        
        r1={0: -56, #SP_lon_ini
            1: -42, #SP_lon_fim          
            2: -28, #SP_lat_ini
            3: -18  #SP_lat_fim      
            } 
        
        r2={0: -46, #lon_ini 
            1: -36, #lon_fim
            2: -27, #lat_ini 
            3: -17, #lat_fim           
            } 

        r3={0: -65, #lon_ini
            1: -53, #lon_fim
            2: -6.35, #lat_ini 
            3: 0.28, #lon_fim                      
            }       
        

        r4={0: -54, #lon_ini 
            1: -44, #lon_fim           
            2: -20, #lat_ini
            3: -10, #lat_fim
            }        
        
        self.dict_regiao={"SP": r1,
                          "RJ": r2,
                          "AM": r3,
                          "DF": r4}       
        
    def imprime_regiao(self):       
        
        if self.regiao.isupper():
                        
            self.lons=(self.dict_regiao[self.regiao][0],self.dict_regiao[self.regiao][1])
            self.lats=(self.dict_regiao[self.regiao][2],self.dict_regiao[self.regiao][3])
                                    
            self.lst.append(self.lons)
            self.lst.append(self.lats)
                       
            return self.lst
        
        else:
           self.regiao=self.regiao.upper()           

           self.lons=(self.dict_regiao[self.regiao][0],self.dict_regiao[self.regiao][1])
           self.lats=(self.dict_regiao[self.regiao][2],self.dict_regiao[self.regiao][3])
            
           self.lst.append(self.lons)
           self.lst.append(self.lats)        
           
           return self.lst
       
    def limpa_lista(self):
        
        self.lst=[]
        
        return self.lst