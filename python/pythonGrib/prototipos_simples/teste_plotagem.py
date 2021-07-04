#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 18 17:27:11 2021

@author: phpimenta
"""

import matplotlib.pyplot as plt
import numpy as np

x = np.expand_dims(np.arange(1,11,1), axis=1)
y = np.expand_dims(np.arange(2,21,2), axis=0)
z = y * x

print(x.shape)
print(y.shape)
print(z.shape)

plt.figure()
plt.contour(z)
plt.show()