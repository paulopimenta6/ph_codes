#!/usr/bin/env python2
#-*- coding:utf-8 -*-

import re

L=[1,2,3]
P=[4,5,6]
M=[7,8,9]

x1=L[0]
x2=P[0]
x3=M[0]

d={}

for i in range(1,3):
    d["x" + str(i)] = i

print(d)    
