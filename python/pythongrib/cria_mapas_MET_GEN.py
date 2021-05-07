#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 27 09:38:57 2021

@author: phpimenta
"""
import pygrib
import numpy as np
from matplotlib import rc
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

# =============================================================================
# Leitura do grib dentro da lib pygrib  
# =============================================================================

file="gfs.t00z.pgrb2.0p25.f003"
grb = pygrib.open(file)

# =============================================================================
# Dicionario de 
# =============================================================================
dict_var_met={"1": "Surface pressure",
              "2": "Pressure",
              "3": ["U component of wind", "V component of wind"],
              "4": "Total preciptation",
              "5": "Total Cloud Cover",
              "6": "Temperature"}

# =============================================================================
# Funcao que le um grib e que le os grids e transforma em grid
# =============================================================================
def grb_to_grid(grb_obj):
    """Takes a single grb object containing multiple
    levels. Assumes same time, pressure levels. Compiles to a cube"""
    n_levels = len(grb_obj)
    levels = np.array([grb_element['level'] for grb_element in grb_obj])
    indexes = np.argsort(levels)[::-1] # highest pressure first
    cube = np.zeros([n_levels, grb_obj[0].values.shape[0], grb_obj[1].values.shape[1]])
    for i in range(n_levels):
        cube[i,:,:] = grb_obj[indexes[i]].values
    cube_dict = {'data' : cube, 'units' : grb_obj[0]['units'],
                 'levels' : levels[indexes]}
    return cube_dict
# =============================================================================
# Variaveis MET
# =============================================================================
print("==========================Variaveis Meteorologicas===========================")
print("1: Pressao em superficie \
      \n2: Pressao [em niveis]  \
      \n3: Vento - resultante das componentes U e V \
      \n4: Preciptacao total \
      \n5: Cobertura total de nuvens \
      \n6: Temperatura")
print("=============================================================================")      
# =============================================================================
# Escolha da variavel
# =============================================================================
var_met_grb=eval(input("Escolha uma variavel:"))
lista_vars_met=grb.select(name=dict_var_met[str(var_met_grb)])


# =============================================================================
# Escolha da variavel meteorologica e 
# consulta do campo:
#
# Os campos sao escolhidos da seguinte maneira:
# pres_sur=grb.select(name="Surface pressure")
# temp=grb.select(name="Temperature")
# =============================================================================




# =============================================================================
# Dicionario de variaveis
# =============================================================================


 
              