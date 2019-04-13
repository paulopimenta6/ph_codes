#!/usr/bin/env python2

#-*- coding:utf-8 -*-


import re

str = "JDialog1"

x = re.match("JDialog[0-9]*", str)

print(x.group())
print(type(x.group()))

x = re.findall("JDialog[0-9]*", str)

print(x)
print(type(x))
print(x[0])
print(type(x[0]))

