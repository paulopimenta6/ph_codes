#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 12 22:51:42 2021

@author: phpimenta
"""
dict_var_teste={}
for i in range(1,10):
    dict_var_teste[i]=i*1000

dict_var_met={1: "Surface pressure",
              2: ["wind"],
              #"2": ["U component of wind", "V component of wind"],
              3: "Total Precipitation",
              4: "Total Cloud Cover",
              5: ["Temperature", "isobaricInPa", dict_var_teste]}


                    
                    