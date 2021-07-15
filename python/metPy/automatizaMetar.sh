#!/bin/bash

data_ano=`date +"%Y"`
data_mes=`date +"%m"`
data_dia=`date +"%d"`
dir="/media/utrecht/12382BE468602ECF/metPy"
dirMetarJson=${data_ano}${data_mes}${data_dia}${data_hora}${data_min}

cd ${dir}
if test -d ${dirMetarJson}
then 
    echo "O diretorio existe"
    cd ${dirMetarJson}
    python3 ../metPy.py
else
    echo "O diretorio nao existe..."
    echo "Criando diretorio..."
    mkdir ${dirMetarJson}
    cd ${dirMetarJson}
    python3 ../metPy.py
fi
