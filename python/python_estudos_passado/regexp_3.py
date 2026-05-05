#!/usr/bin/env python2

#-*- coding:utf-8 -*-

import re

str = "The rain in Spain"
x = re.sub("\s", "9", str)
print(x)
