#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 22 04:07:55 2021

@author: paulopimenta
"""

from MET_ponto_regiao import met_ponto_regiao
from leitor_GRIB import leitor_de_GRIB
from leitura_dados_MET import leitura_dados_met

# =============================================================================
# Lendo GRIB
# =============================================================================
grb=leitor_de_GRIB()

# =============================================================================
# Escolhendo variavel
# =============================================================================
dadosMET=leitura_dados_met()
dadosMET.escolher_varMET()
# =============================================================================
# Escolhendo os pontos
# =============================================================================
lonlat=met_ponto_regiao(360,90)
lonlat.verifica_longitude()
lonlat.verifica_latitude()

print("lon ini: " + str(lonlat.lon_ini))
print("lon fim: " + str(lonlat.lon_fim))
print("lat ini: " + str(lonlat.lat_ini))
print("lat fim: " + str(lonlat.lat_fim))

