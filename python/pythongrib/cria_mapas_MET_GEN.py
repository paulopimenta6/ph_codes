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
# Variaveis globais
# =============================================================================
lista_niveis=[]

# =============================================================================
# Leitura do grib dentro da lib pygrib  
# =============================================================================
file="gfs.t00z.pgrb2.0p25.f003"
grb = pygrib.open(file)

# =============================================================================
# Dicionario de variaveis padrao
# =============================================================================
dict_var_met={"1": ["Surface pressure", "surface"],
              "2": ["Total Precipitation", "surface"],
              "3": ["Total Cloud Cover", "isobaricInhPa"], 
              "4": ["Temperature", "isobaricInhPa"]}
              #"4": ["Temperature", "isobaricInhPa"]
              #"5": ["U component of wind", "V component of wind"]

    
SP={0: -28, #"SP_lat_ini:  llcrnrlat: -28 
    1: -18, #"SP_lat_fim": urcrnrlat: -18
    2: 304, #"SP_lon_ini": llcrnrlon: 304
    3: 320} #"SP_lon_fim": urcrnrlon: 320

dict_regiao={1: SP}
             #"2": RJ,
             #"3": Manaus,
             #"4": Brasilia}
             
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
# Funcao que define a variavel e carrega as variaveis 
# com algumas caracteristicas
# =============================================================================

#TypeOfLevel="isobaricInPa"

# =============================================================================
# Variaveis MET
# =============================================================================
print("==========================Variaveis Meteorologicas===========================")
print("1: Surface pressure \
      \n2: Total Precipitation \
      \n3: Total Cloud Cover \
      \n4: Temperature")
print("=============================================================================")      
# =============================================================================
# Escolha da variavel
# =============================================================================
var_met_grb=eval(input("Escolha uma variavel:"))
print("Foi escolhido a variavel: " + dict_var_met[str(var_met_grb)][0])
name_var_met=dict_var_met[str(var_met_grb)[0]]
tipo_nivel=dict_var_met[str(var_met_grb)][1]

lista_vars_met=grb.select(name=name_var_met, typeOfLevel=tipo_nivel)

if len(lista_vars_met)>2:    
    # print(lista_vars_met)
    for n in lista_vars_met:
        if n.level > 150:
        # print((n.level))
            lista_niveis.append(n.level)            
    # Transformando os niveis em dicionario 
    # Assim ficara melhor para o usuario visualizar e 
    # Escolher melhor o nivel      
    index=list(range(1, len(lista_niveis)+1))    
    dict_niveis=dict(zip(index, lista_niveis))
    
    for i in dict_niveis:
        print(str(i) + ": " + str(dict_niveis[i]) + " hPa")
   
    nivel_escolhido=eval(input("Escolha um nivel: "))
    print("O nivel escolhido foi " + str(dict_niveis[nivel_escolhido]) + " hPa")
    lista_vars_met=grb.select(name=name_var_met, typeOfLevel=tipo_nivel, level=dict_niveis[nivel_escolhido])
else:
    # so havera um nivel
    # o nivel sera o unico presente mesmo
    
    #lista_niveis.append(lista_vars_met[0].level)    
    #index=list(range(1, len(lista_niveis)+1))
    #dict_niveis=dict(zip(index, lista_niveis))    
    
    #for i in dict_niveis:
    #    print(str(i) + ": " + str(dict_niveis[i]) + " hPa")
   
    #nivel_escolhido=eval(input("Escolha um nivel: "))
    #print("O nivel escolhido foi " + str(dict_niveis[nivel_escolhido]) + " hPa")
    print("So ha um nivel para o tipo de nivel: " + tipo_nivel)
    nivel_escolhido=lista_vars_met[0].level
    lista_vars_met=grb.select(name=name_var_met, typeOfLevel=tipo_nivel, level=nivel_escolhido)        
    
#Editar o hpa da mensagens dos prints, pois em niveis de superficie os mesmos nao usam hPa    
    
# =============================================================================
# Definicao da regiao
# =============================================================================
lat_reg=lista_vars_met[0].distinctLatitudes
lon_reg=lista_vars_met[0].distinctLongitudes
print("Regioes de interesse: \n")
print("1: SP \
      \n2: RJ \
      \n3: Manaus \
      \n4: Brasilia")
var_met_reg=eval(input("Escolha uma regiao: "))
lats_lons_regs_escolhida=dict_regiao[var_met_reg]

m = Basemap(projection='mill', 
            llcrnrlat=lats_lons_regs_escolhida[0], 
            urcrnrlat=lats_lons_regs_escolhida[1],
            llcrnrlon=lats_lons_regs_escolhida[2],
            urcrnrlon=lats_lons_regs_escolhida[3],
            resolution='i')

# =============================================================================
# Dicionario de variaveis
# =============================================================================


 
              