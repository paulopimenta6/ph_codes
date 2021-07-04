#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 18 03:04:31 2021

@author: paulopimenta
"""

import pygrib
import numpy as np
from matplotlib import rc
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
from mpl_toolkits.basemap import shiftgrid

# =============================================================================
# Leitura do grib dentro da lib pygrib  
# =============================================================================
file="../grib/gfs.t00z.pgrb2.0p25.f003"
grb = pygrib.open(file)

temp=grb.select(name="Temperature", typeOfLevel="isobaricInhPa", level=1000)[0]
lons, lats = temp.latlons()
#lats=temp.distinctLatitudes
#lons=temp.distinctLongitudes
valores=temp.values
#valores, lons=shiftgrid(180., valores, lons, start=False)

# =============================================================================
# Alinhando as grades
# =============================================================================
#lons,lats=np.meshgrid(lons,lats)

#outra forma de chamar lat e lon y,x = temp.latlons()
#extract data, lats and lons for a subset region defined by the keywords lat1,lat2,lon1,lon2.
#varMET, lat, lon = temp.data(lat1=-35,lat2=-25,lon1=302,lon2=315)

  