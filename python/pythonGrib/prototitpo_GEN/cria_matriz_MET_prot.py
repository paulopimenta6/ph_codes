#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 27 19:48:06 2021

@author: phpimenta
"""
import pygrib
from mpl_toolkits.basemap import Basemap
from mpl_toolkits.basemap import shiftgrid
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib import rc

file="gfs.t00z.pgrb2.0p25.f003"
grb=pygrib.open(file)

# =============================================================================
#import numpy as np
# import pandas as pd
# 
# mat_ex1=np.zeros((10,5))
# 
# print(mat_ex1)
# [[0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]
#  [0. 0. 0. 0. 0.]]
# lat=np.arange(-30,-20)
# 
# mat_ex1.shape
# Out[7]: (10, 5)
# 
# lat.shape
# Out[8]: (10,)
# 
# print(lat)
# [-30 -29 -28 -27 -26 -25 -24 -23 -22 -21]
# 
# lon=np.arange(350,355)
# 
# lon
# Out[11]: array([350, 351, 352, 353, 354])
# 
# df_ex=pd.DataFrame(mat_ex1, index=lat, columns=lon)
# 
# df_ex
# Out[13]: 
#      350  351  352  353  354
# -30  0.0  0.0  0.0  0.0  0.0
# -29  0.0  0.0  0.0  0.0  0.0
# -28  0.0  0.0  0.0  0.0  0.0
# -27  0.0  0.0  0.0  0.0  0.0
# -26  0.0  0.0  0.0  0.0  0.0
# -25  0.0  0.0  0.0  0.0  0.0
# -24  0.0  0.0  0.0  0.0  0.0
# -23  0.0  0.0  0.0  0.0  0.0
# -22  0.0  0.0  0.0  0.0  0.0
# -21  0.0  0.0  0.0  0.0  0.0
# 
# =============================================================================

# =============================================================================
# lon2=df_ex.columns.values
# 
# lon2
# Out[15]: array([350, 351, 352, 353, 354])
# 
# lat2=df_ex.index.values
# 
# lat2
# Out[17]: array([-30, -29, -28, -27, -26, -25, -24, -23, -22, -21])
# =============================================================================

grb_surface_pressure=grb.select(name="Surface pressure")
surface_pressure=grb_surface_pressure[0].values

lons = np.linspace(float((grb_surface_pressure[0])['longitudeOfFirstGridPointInDegrees']), \
float((grb_surface_pressure[0])['longitudeOfLastGridPointInDegrees']), int((grb_surface_pressure[0])['Ni']) )
 
lats=np.linspace(float((grb_surface_pressure[0])['latitudeOfFirstGridPointInDegrees']), \
float((grb_surface_pressure[0])['latitudeOfLastGridPointInDegrees']), int((grb_surface_pressure[0])['Nj']) ) 

def fnear(array, value):
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx
    #lons variando de 304 320
    #lats variando de -18 -28

lon_sp=lons[fnear(lons,304):fnear(lons,320)+1]
lat_sp=lats[fnear(lats,-18):fnear(lats,-28)+1]
surfpres_sp=surface_pressure[fnear(lats,-18):fnear(lats,-28)+1,fnear(lons,304):fnear(lons,320)+1]

df_mapa_sp=pd.DataFrame(surfpres_sp, index=lat_sp, columns=lon_sp)
df_mapa_sp.to_csv('filename.csv')



