#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun  2 07:10:59 2021

@author: phpimenta
"""
# =============================================================================
# Libs usadas
# =============================================================================
import pygrib
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap, shiftgrid

# =============================================================================
# Dicionario da regiao
# =============================================================================
SP={0: -28, #SP_lat_ini:  llcrnrlat: -28 
    1: -18, #SP_lat_fim": urcrnrlat: -18
    2: -56, #SP_lon_ini": llcrnrlon: 304
    3: -42} #SP_lon_fim": urcrnrlon: 320

# =============================================================================
# Arquivo a ser lido
# =============================================================================
file="gfs.t00z.pgrb2.0p25.f003"
grb=pygrib.open(file)    
    
# =============================================================================
# U Wind of Component
# =============================================================================
lst_uWind=grb.select(name='U component of wind', typeOfLevel='isobaricInhPa', level=1000) #Nivel de teste
uWind=lst_uWind[0]
# =============================================================================
# V Wind of Component
# =============================================================================
lst_vWind=grb.select(name='V component of wind', typeOfLevel='isobaricInhPa', level=1000) #Nivel de teste
vWind=lst_vWind[0]
# =============================================================================
# Coordenadas
# =============================================================================
lons = np.linspace(float(uWind['longitudeOfFirstGridPointInDegrees']), \
float(uWind['longitudeOfLastGridPointInDegrees']), int(uWind['Ni']) )
    
lats=np.linspace(float(vWind['latitudeOfFirstGridPointInDegrees']), \
float(vWind['latitudeOfLastGridPointInDegrees']), int(vWind['Nj']) )

#lons_reg, lats_reg = np.meshgrid(lons, lats)

# =============================================================================
# Magnitude do vento
# =============================================================================
uWind_mag=uWind.values
vWind_mag=vWind.values

# =============================================================================
# Selcionando o interior da lista
# =============================================================================

uWind_grid, newlons = shiftgrid(180., uWind_mag, lons, start=False)
vWind_grid, newlons = shiftgrid(180., vWind_mag, lons, start=False)

# =============================================================================
# Plotando mapa de vento
# =============================================================================
lats=lats[::-1]
lons_grid, lats_grid = np.meshgrid(lons, lats)
m = Basemap(resolution='c',projection='ortho',lat_0=-30.,lon_0=-60.)
fig1 = plt.figure(figsize=(14,20))
ax = fig1.add_axes([0.1,0.1,0.8,0.8])
clevs = np.arange(960,1061,5)
x, y = m(lons_grid, lats_grid)
parallels = np.arange(-80.,90,20.)
meridians = np.arange(0.,360.,20.)
#CS1 = m.contour(x,y,slp,clevs,linewidths=0.5,colors='k',animated=True)
#CS2 = m.contourf(x,y,slp,clevs,cmap=plt.cm.RdBu_r,animated=True)
uproj,vproj,xx,yy = \
m.transform_vector(uWind_grid,vWind_grid,newlons,lats,31,31,returnxy=True,masked=True)
Q = m.quiver(xx,yy,uproj,vproj,scale=700)
qk = plt.quiverkey(Q, 0.1, 0.1, 20, '20 m/s', labelpos='W')
#m.fillcontinents(color='coral',lake_color='aqua')
#m.drawmapboundary(fill_color='aqua')
m.drawcoastlines(linewidth=1.5)
m.drawcountries(linewidth=0.25)
m.drawparallels(parallels)
m.drawmeridians(meridians)











