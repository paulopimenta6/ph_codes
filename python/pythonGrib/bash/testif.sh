#!/bin/bash

if test -n "${1}" && [[ "${1}" == "teste" ]]
then
    echo "Nao vazio"
    echo "${1}"
else
    echo "Vazio"
fi
