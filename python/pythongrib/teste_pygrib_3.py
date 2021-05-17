#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 26 23:36:29 2021

@author: phpimenta
"""

import pygrib

file="gfs.t00z.pgrb2.0p25.f003"
gr = pygrib.open(file)

#for g in gr:
#    print(g)
    
for g in gr:
  print("name: ", g.name)
  print("typeOfLevel: ", g.typeOfLevel)
  print("level: ", g.level)  
  print("validDate: ", g.validDate)
  print("analDate: ", g.analDate)
  print("forecastTime: ", g.forecastTime)

