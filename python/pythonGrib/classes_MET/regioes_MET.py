#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 28 09:17:29 2021

@author: paulopimenta
"""

from regioes_predefinidas_MET import regioes_predefinidas
from ponto_regiao_MET import met_ponto_regiao
from parse_param_MET import parse_param
import sys

# =============================================================================
# Parseando e adquirindo as variaveis
# Ajustando as variaveis
# =============================================================================

varMET, varNivel, varRegiao = parse_param(sys.argv).imprime_parse()
if (type(varRegiao) is tuple):
    varRegiao=list(varRegiao)
    lon=int(varRegiao[0])
    lat=int(varRegiao[1]) 

# =============================================================================
# Passando as variaveis para a classe correspondente - Usando a classe ponto_regiao_MET
# =============================================================================

if (type(varRegiao) is list):    
    ptos=met_ponto_regiao(lon, lat)
    lonslats=ptos.imprime_longitude_latitude()
    print(lonslats)

# =============================================================================
# Passando as variaveis para a classe correspondente - Usando a classe regioes_predefinidas_MET
# =============================================================================

if (type(varRegiao) is str):
    ptos=regioes_predefinidas(varRegiao)
    lonslats=ptos.imprime_regiao()
    print(lonslats)