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
from mpl_toolkits.basemap import shiftgrid

# =============================================================================
# Variaveis globais
# =============================================================================
lista_niveis=[]

# =============================================================================
# Leitura do grib dentro da lib pygrib  
# =============================================================================
file="../grib/gfs.t00z.pgrb2.0p25.f003"
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

    
SP={0: -28, #SP_lat_ini:  llcrnrlat: -28 
    1: -18, #SP_lat_fim": urcrnrlat: -18
    2: -56, #SP_lon_ini": llcrnrlon: 304
    3: -42} #SP_lon_fim": urcrnrlon: 320

RJ={0: -24, #RJ_lat_ini:  llcrnrlat: -24 
    1: -20, #RJ_lat_fim": urcrnrlat: -20
    2: -45, #RJ_lon_ini": llcrnrlon: -45
    3: -37} #RJ_lon_fim": urcrnrlon: -37

AM={0: -6.35, #AM_lat_ini:  llcrnrlat: -6.35 
    1: 0.28,  #AM_lat_fim": urcrnrlat: -0.28
    2: -65,   #AM_lon_ini": llcrnrlon: -65
    3: -53}   #AM_lon_fim": urcrnrlon: -53

DF={0: -20, #DF_lat_ini:  llcrnrlat: -16
    1: -10, #DF_lat_fim": urcrnrlat: -15
    2: -54, #DF_lon_ini": llcrnrlon: -49
    3: -44} #DF_lon_fim": urcrnrlon: -46

dict_regiao={1: SP,
             2: RJ,
             3: AM,
             4: DF}
          
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
name_var_met=dict_var_met[str(var_met_grb)][0]
tipo_nivel=dict_var_met[str(var_met_grb)][1]

lista_vars_met=grb.select(name=name_var_met, typeOfLevel=tipo_nivel)
unidade_var_met=lista_vars_met[0].units


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
# Adquirindo valor e deixando a grade de longitudes entre -180 ate 180
# =============================================================================

# Pegando valores de latitudes e longitudes
lat_reg=lista_vars_met[0].distinctLatitudes
lon_reg=lista_vars_met[0].distinctLongitudes

# Adquirindo os valores e reorientando os valores das longitudes de -180 a 180
data=lista_vars_met[0].values
data, lon_reg=shiftgrid(180., data, lon_reg, start=False)

# Adquirindo os valores de maximo, minimo e unidade 
max_var_met=data.max()
min_var_met=data.min()
intervalo=(max_var_met-min_var_met)
#unidade_var_met=lista_vars_met[0].units

# =============================================================================
# Definicao da regiao
# =============================================================================
print("Regioes de interesse: \n")
print("1: SP \
      \n2: RJ \
      \n3: Manaus \
      \n4: Brasilia")
var_met_reg=eval(input("Escolha uma regiao: "))
lats_lons_reg_escolhida=dict_regiao[var_met_reg]

# =============================================================================
# Cortando para area de interesse
# =============================================================================
#Load=loadt[fnear(loadt,lnmn)-2:fnear(loadt,lnmx)+2] 
#Laad=laadt[fnear(laadt,ltmn)-2:fnear(laadt,ltmx)+2] 
#LOadt,LAadt=np.meshgrid(Load,Laad)

# =============================================================================
# Plotando mapas
# =============================================================================

m = Basemap(projection='mill',
            llcrnrlat=lats_lons_reg_escolhida[0], 
            urcrnrlat=lats_lons_reg_escolhida[1],
            llcrnrlon=lats_lons_reg_escolhida[2],
            urcrnrlon=lats_lons_reg_escolhida[3],
            resolution='i')

rc('font',weight='normal') 
rc('xtick',labelsize=12)  
rc('font',size=12)
rc('ytick',labelsize=12)    
plt.figure(figsize=(8,10))
lons_grid,lats_grid=np.meshgrid(lon_reg,lat_reg)
x, y = m(lons_grid, lats_grid)

meridianinterval=np.arange(lats_lons_reg_escolhida[2],lats_lons_reg_escolhida[3],2)
parallelsinterval=np.arange(lats_lons_reg_escolhida[0],lats_lons_reg_escolhida[1])
m.drawparallels(parallelsinterval,labels=[1,0,0,0],  color='k',linewidth=.3)
m.drawmeridians(meridianinterval,labels=[0,0,0,1],color='k',linewidth=.3)

m.drawcoastlines()
m.drawcountries()
m.drawstates()

contourf = m.contourf(x, y, np.squeeze(data),cmap='viridis', levels=np.linspace(int(min_var_met), int(max_var_met), int(intervalo)))
cs1 = m.contour(x, y, np.squeeze(data),colors='k', levels=np.linspace(int(min_var_met), int(max_var_met), int(intervalo)), linewidths=0.2)
#contourf = m.contourf(x, y, np.squeeze(data),cmap='GnBu', levels=np.linspace(min_var_met, max_var_met, 200))
#cs1 = m.contour(x, y, np.squeeze(data),colors='k', levels=np.linspace(min_var_met, max_var_met, 200), linewidths=0.2)
plt.clabel(cs1,fmt='%d',fontsize=8)

print(contourf)
cbar=m.colorbar(contourf, location='right', pad="1%")
cbar.set_label(unidade_var_met)
plt.show()
# =============================================================================
# Dicionario de variaveis
# =============================================================================