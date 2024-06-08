#!/usr/bin/env python2

#-*- coding:utf-8 -*-

import re

str = "The rain in Spain falls mainly in the plain!"

#Check if the string contains "a" followed by exactly two "l" characters:

x = re.findall("al{2}", str)

print(x)

if (x):
  print("Yes, there is at least one match!")
else:
  print("No match")
