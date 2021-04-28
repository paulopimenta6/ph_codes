#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 27 09:38:57 2021

@author: phpimenta
"""
import pygrib

file="gfs.t00z.pgrb2.0p25.f003"
gr = pygrib.open(file)


#Campo de pressao em superficie
#O nivel de pressao e 0 pois esta na superficie
pres_sur=gr.select(name="Surface pressure")

#Campo de pressao em niveis diferentes
