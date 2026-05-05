#!/usr/bin/env python2
#-*- coding:utf-8 -*-

#N = 0,15 * (P1 + P2 + PTOT + Fo + SF + L) + 0,10 * C

P1 = 7.5
P2 = 2.6

PTOT=3.5

Fo = PTF = 6.0
SF = 6.5
L = 4.4
C = 5.0

N1 = 0.15*(P1 + P2 + PTOT + Fo + SF + L) 
N2 = 0.10*C
N=N1+N2
print(N)
