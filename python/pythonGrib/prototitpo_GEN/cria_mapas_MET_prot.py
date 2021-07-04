#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 23 21:10:34 2021

@author: phpimenta
"""

import pygrib
from mpl_toolkits.basemap import Basemap
from mpl_toolkits.basemap import shiftgrid
import geojsoncontour
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib import rc

grib = ("../grib/gfs.t00z.pgrb2.0p25.f003");
gr = pygrib.open(grib)

for g in gr:
    print(g)

print("#################")
grb=gr.select()[0]
data=grb.values

lons = np.linspace(float(grb['longitudeOfFirstGridPointInDegrees']), \
float(grb['longitudeOfLastGridPointInDegrees']), int(grb['Ni']) )
    
lats=np.linspace(float(grb['latitudeOfFirstGridPointInDegrees']), \
float(grb['latitudeOfLastGridPointInDegrees']), int(grb['Nj']) )    
print("#################")    
#grb = gr.select(name='Surface pressure')
#print(grb)
grb = gr.select(name='Surface pressure')[0]

#data, lats, lons = grb.data(lat1=-35,lat2=-25,lon1=302,lon2=315)
print(grb)

m = Basemap(projection='mill',llcrnrlat=-28,urcrnrlat=-18,\
            llcrnrlon=304,urcrnrlon=320,resolution='i')
rc('font',weight='normal') 
rc('xtick',labelsize=12)  
rc('font',size=12)
rc('ytick',labelsize=12)    
plt.figure(figsize=(8,10))
lons_grid,lats_grid=np.meshgrid(lons,lats)
x, y = m(lons_grid, lats_grid)

meridianinterval=np.arange(304,320,2)
parallelsinterval=np.arange(-28,-18)
m.drawparallels(parallelsinterval,labels=[1,0,0,0],  color='k',linewidth=.3)
m.drawmeridians(meridianinterval,labels=[0,0,0,1],color='k',linewidth=.3)

#print("###")
#print(x)
#print("###")
#print(y)
#print("###")

m.drawcoastlines()
m.drawcountries()
m.drawstates()

contourf = m.contourf(x, y, np.squeeze(data),cmap='GnBu', levels=np.linspace(100900, 102100, 41))
cs1 = m.contour(x, y, np.squeeze(data),colors='k', levels=np.linspace(100900, 102100, 21), linewidths=0.2)
plt.clabel(cs1,fmt='%d',fontsize=8)

print(contourf)
cbar=m.colorbar(contourf, location='right', pad="1%")
cbar.set_label("hPa")

#geojson = geojsoncontour.contourf_to_geojson(
#    contourf=contourf,
#    min_angle_deg=3.0,
#    ndigits=3,
#    stroke_width=2,
#)
plt.title('Pressão em superfície - 21-Jan-2020 às 01:40 am', weight="normal", fontsize=12)
plt.savefig('campomedio2.png',bbox_inches='tight')
plt.show()

#print(geojson)    