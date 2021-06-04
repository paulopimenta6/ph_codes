#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun  2 11:21:32 2021

@author: phpimenta
"""

# Importing library
import matplotlib
  
# Create figure() objects
# This acts as a container
# for the different plots
fig = matplotlib.pyplot.figure()
  
# Creating axis
# add_axes([xmin,ymin,dx,dy])
axes = fig.add_axes([0.5, 0.5, 0.8, 0.8])
  
# Depict illustration
fig.show()