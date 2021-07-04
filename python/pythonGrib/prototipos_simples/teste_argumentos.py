#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 11 15:25:03 2021

@author: phpimenta
"""

#./automatiza.sh -v temp -n 19 -r SP
#./automatiza.sh --versao temp --nivel 19 --regiao SP
#./automatiza.sh -v temp -n 19 -ll -30 -56   	

# -*- coding: utf-8 -*-
import sys

param = sys.argv
if len(param)>1:
    if param[1]=="-v" or param[1]=="--variavel":
        varMET=param[2]
        if param[3]=="-n" or param[3]=="--nivel":
            varNivel=param[4]
            if param[5]=="-r" or param[5]=="--regiao":
                varRegiao=param[6]
            elif param[5]=="-ll" or param[5]=="--latlon":
                varRegiao=param[6],param[7]
            else:
                print("Variavel Regiao vazia")
        else:
            print("Variavel Nivel vazia")
    else:
        print("Variavel MET vazia")
else:
    print("Sem parametros")

print(varMET, varNivel, varRegiao)    
