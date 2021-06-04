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
# Dicionario de variaveis padrao
# =============================================================================

SP={0: -28, #SP_lat_ini:  llcrnrlat: -28 
    1: -18, #SP_lat_fim": urcrnrlat: -18
    2: -56, #SP_lon_ini": llcrnrlon: 304
    3: -42} #SP_lon_fim": urcrnrlon: 320

RJ={0: -27,  
    1: -17, 
    2: -46, 
    3: -36} 

AM={0: -6.35, 
    1: 0.28,
    2: -65, 
    3: -53} 

DF={0: -20, 
    1: -10, 
    2: -54, 
    3: -44} 

dict_regiao={1: SP,
             2: RJ,
             3: AM,
             4: DF}

dict_var_met={1: ["Surface pressure", "surface"],            
              2: ["Temperature", "isobaricInhPa"]}

# =============================================================================
# Funcoes  
# =============================================================================

def escolher_var():
      
    print("==========================Variaveis Meteorologicas===========================")
    print("1: Surface pressure \
          \n2: Temperature")
    print("=============================================================================")    
    
    var_met_grb=eval(input("Escolha uma variavel:"))
    print("Foi escolhido a variavel: " + dict_var_met[var_met_grb][0])
    return var_met_grb    

def extrai_var(var_met_grb):

    name_var_met=dict_var_met[var_met_grb][0]
    tipo_nivel=dict_var_met[var_met_grb][1]
    
    return name_var_met, tipo_nivel

def listaVar(name_var_met, tipo_nivel):

    lista_vars_met=[]
    lista_vars_met=grb.select(name=name_var_met, typeOfLevel=tipo_nivel)    
    
    return lista_vars_met    

def escolha_nivel(name_var_met, tipo_nivel, lista_vars_met):

    lista_niveis=[]
    lista_nivel_escolhida=[]

    if len(lista_vars_met)>2:
        for n in lista_vars_met:
            if n.level > 150:
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
        lista_nivel_escolhida=grb.select(name=name_var_met, typeOfLevel=tipo_nivel, level=dict_niveis[nivel_escolhido])
    else:
    # so havera um nivel
    # o nivel sera o unico presente mesmo    
   
        print("So ha um nivel para o tipo de nivel: " + tipo_nivel)
        nivel_escolhido=lista_vars_met[0].level
        lista_nivel_escolhida=grb.select(name=name_var_met, typeOfLevel=tipo_nivel, level=nivel_escolhido)

    return lista_nivel_escolhida 

def extrai_valor(listaVarsMetEscolhida):

    # Adquirindo os valores e reorientando os valores das longitudes de -180 a 180
    data=listaVarsMetEscolhida[0].values

    return data

def extrai_max_min(data):

    # Adquirindo os valores de maximo, minimo e unidade    
    min_var_met=data.min()
    max_var_met=data.max()
    
    return min_var_met, max_var_met

def extrai_lat_lon(lista_nivel_escolhida, data):
        
    # Pegando valores de latitudes e longitudes
    lat_reg=lista_nivel_escolhida[0].distinctLatitudes
    lon_reg=lista_nivel_escolhida[0].distinctLongitudes
    data, lon_reg=shiftgrid(180., data, lon_reg, start=False)

    return lat_reg, lon_reg

def extrai_unidade(lista_nivel_escolhida):
    
    unidade_var_met=lista_nivel_escolhida[0].units
    
    return unidade_var_met

def converte_unidade_e_valor(data, unidade_var_met):
    
    if unidade_var_met=='K':
       unidade_var_met='C'
       # Convertendo de K para C
       data_convertida = data-273.15

    if unidade_var_met=='Pa':
        unidade_var_met='mbar'
        data_convertida = data/100
        
    return data_convertida, unidade_var_met 

def O(dataVars):
    
    min_var_met=dataVars.min()
    max_var_met=dataVars.max()
    
    intervalo_valores=[]
    
    if len(dataVars)<=50:
        o=30
        #intervalo_valores=dataVars[::o]
        intervalo_valores=np.linspace(int(min_var_met), int(max_var_met), o)

    elif 50<len(dataVars)<=100:
        o=50
        #intervalo_valores=dataVars[::o]
        intervalo_valores=np.linspace(int(min_var_met), int(max_var_met), o)
    
    elif 100<len(dataVars)<=500:
        o=70
        #intervalo_valores=dataVars[::o]
        intervalo_valores=np.linspace(int(min_var_met), int(max_var_met), o)
    
    elif 500<len(dataVars)<=1000:
        o=90
        #intervalo_valores=dataVars[::o]
        intervalo_valores=np.linspace(int(min_var_met), int(max_var_met), o)

    elif 1000<len(dataVars)<=10000:
        o=110
        #intervalo_valores=dataVars[::o]
        intervalo_valores=np.linspace(int(min_var_met), int(max_var_met), o)

    else:
        o=500
        #intervalo_valores=dataVars[::o]
        intervalo_valores=np.linspace(int(min_var_met), int(max_var_met), o)
    
    #intervalo=len(intervalo_valores)
    return min_var_met, max_var_met, intervalo_valores

def escolhe_regiao():
    
    print("Regioes de interesse: \n")
    print("1: SP \
          \n2: RJ \
          \n3: Manaus \
          \n4: Brasilia")

    var_met_reg=eval(input("Escolha uma regiao: "))
    lats_lons_reg_escolhida=dict_regiao[var_met_reg]    

    return lats_lons_reg_escolhida

def plota_mapa(lats_lons_reg_escolhida, lon_reg, lat_reg, data, min_var_met, max_var_met, intervalo_valores, unidade): 
    
    # Usa o resultado da funcao extrai_valor(listaVarsMetEscolhida)
    # que e o valor correspondente a matriz de valores da variavel
    # escolhida

    m = Basemap(projection='mill',
        llcrnrlat=lats_lons_reg_escolhida[0], 
        urcrnrlat=lats_lons_reg_escolhida[1],
        llcrnrlon=lats_lons_reg_escolhida[2],
        urcrnrlon=lats_lons_reg_escolhida[3],
        resolution='i')

    # Usar a funcao extrai_lat_lon(lista_nivel_escolhida, data) para pegar os lat_reg e lon_reg

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

    # Usar a funcao extrai_valor(listaVarsMetEscolhida) para obter o valor de data
    # Usar a funcao extrai_max_min(data) para obter os valores de min e max de valor

    contourf = m.contourf(x, y, np.squeeze(data),cmap='viridis', levels=intervalo_valores)
    cs1 = m.contour(x, y, np.squeeze(data),colors='k', levels=intervalo_valores, linewidths=0.2)

    plt.clabel(cs1,fmt='%d',fontsize=8)

    print(contourf)
    cbar=m.colorbar(contourf, location='right', pad="1%")
    cbar.set_label(unidade)
    #plt.show()    

#def cria_matriz()

# =============================================================================
# Leitura do grib dentro da lib pygrib  
# =============================================================================
file="gfs.t00z.pgrb2.0p25.f003"
grb = pygrib.open(file)

# =============================================================================
# Prototipos de uso das funcoes  
# =============================================================================
varMetDict = escolher_var()
varMet,VarTipoNivel = extrai_var(varMetDict)
listaVarsMet = listaVar(varMet,VarTipoNivel)
listaVarsMetEscolhida = escolha_nivel(varMet,VarTipoNivel, listaVarsMet)

# =============================================================================
# Extraindo dados da variavel
# =============================================================================
dataVars=extrai_valor(listaVarsMetEscolhida)
unidade=extrai_unidade(listaVarsMetEscolhida)

# =============================================================================
# Escolhendo lat e lon
# =============================================================================
lat, lon = extrai_lat_lon(listaVarsMetEscolhida, dataVars)
regiao=escolhe_regiao()

# =============================================================================
# Converte valores e unidades
# =============================================================================
novo_valor, nova_unidade = converte_unidade_e_valor(dataVars, unidade)
minData, maxData, intervalos=O(novo_valor)
# =============================================================================
# Plotando Mapa ou Matriz
# =============================================================================
plota_mapa(regiao, lon, lat, novo_valor, minData, maxData , intervalos, nova_unidade)
#plota_mapa(lats_lons_reg_escolhida, lon_reg, lat_reg, data, min_var_met, max_var_met, intervalo_valores, unidade)