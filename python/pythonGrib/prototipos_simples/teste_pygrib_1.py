import pygrib
from mpl_toolkits.basemap import Basemap
from mpl_toolkits.basemap import shiftgrid
import matplotlib.pyplot as plt
import geojsoncontour
import numpy as np
import pandas as pd

grib = ('gfs.t00z.pgrb2.0p25.f003')
gr = pygrib.open(grib)

#for g in gr:
#    print(g)

dado=gr[421]
temp_vals = dado.values  
x = pd.DataFrame(temp_vals[:]) 
#print(x)  
#print("#########################")
#print(" ")

#grb = gr.select(name='Surface pressure')[0]
grb = gr.select(name='Temperature',typeOfLevel='isobaricInhPa')[8]
data, lats, lons = grb.data(lat1=-35,lat2=-25,lon1=302,lon2=315)
#print("#########################")
#print("Data abaixo!!")
#print(data)
#print("+++++++++")
#print(lats)
#print(lons)
print(grb)

#print("#########################")

m = Basemap(projection='mill',llcrnrlat=-35,urcrnrlat=-25,\
            llcrnrlon=302,urcrnrlon=315,resolution='i')

plt.figure(figsize=(8,10))

x, y = m(lons, lats)

m.drawcoastlines()
m.drawcountries()
m.drawstates()

contourf = m.contourf(x, y, np.squeeze(data),cmap='GnBu')

#print(contourf)
m.colorbar(contourf, location='right', pad="10%")

geojson = geojsoncontour.contourf_to_geojson(
    contourf=contourf,
    min_angle_deg=3.0,
    ndigits=3,
    stroke_width=2,
)
plt.title('Pressão em superfície - 21-Jan-2020 às 01:40 am')
plt.show()
#print(geojson)
