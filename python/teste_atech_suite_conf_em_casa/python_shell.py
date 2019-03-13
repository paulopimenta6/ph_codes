#!/usr/bin/env python
#-*- coding:utf-8 -*- 

import os
import re

dir="/home/paulopimenta/Documentos/meus_codigos/ph_codes/python/"

######Listando diretorios:


arquivos_py=os.listdir(dir)
print(arquivos_py)
#print(os.getcwd())
#print(os.isdir(dir))


######abrindo um arquivo:
arquivo=open("suite.conf", "r")
for linha in arquivo.readlines():
    arquivo=linha.split("=")
    for termo in arquivo:
        if "tst_case" in termo:
            termo=termo.split()
            print(termo)
            print(len(termo))

  

