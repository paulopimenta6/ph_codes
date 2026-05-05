#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 25 00:29:55 2022

@author: paulopimenta
"""

from pylab import plot, arange

print('\n'*100)

x = arange(0, 4, 0.5)
y = 2*x
y1 = 6*x
y2 = x**2

plot(x, y, x, y1, x, y2)