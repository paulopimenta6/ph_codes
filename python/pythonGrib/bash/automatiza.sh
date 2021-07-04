#!/bin/bash

echo "=============================================================================="
echo "Automacao em Python para servidor MET" 
echo "=============================================================================="

mensagem_de_uso="$(basename "$0") [OPCOES]

	OPCOES:	   

	-h | --help	Mostra menu de ajuda \n
	-v | --variavel		temp: Temperatura ou ps: Pressao em Superficie \n
	-n | --nivel de altitude	Os niveis de altitude sao dados em niveis de pressao \n
	-r | --regiao	Regiao de interesse como SP, RJ, DF ou MN \n
	-ll | --lonlat	Dado uma lon (-180 a 180) e lat (-90 a 90) e definido uma regiao de interesse \n

	exemplos de uso: ./automatiza.sh -v temp -n 19 -r SP
                         ./automatiza.sh --variavel temp --nivel 19 --regiao SP
                         ./automatiza.sh -v temp -n 19 -ll -56 -30   	
"

if test -z "${1}"
then

    echo -e "${mensagem_de_uso}"

fi

#Pegando a variavel MET
if test -n "${1}" && [[ "${1}" == "-v" || "${1}" == "--variavel" ]]
then
    case "${1}" in
        -v | --variavel) #A variavel MET de identificacao foi achada
            if test -n "${2}" #A variavel de valor da variavel MET sendo identificada
                then
                    echo "Variavel MET: ${2}"
            else
                echo "Variavel MET: Vazio"
                exit 0
            fi         
    esac
fi     

#Pegando o nivel de altitude
if test -n "${3}" && [[ "${3}" == "-n" || "${3}" == "--nivel" ]]
then
    case "${3}" in
        -n | --nivel) #A variavel de nivel de altitude sendo identificada
            if test -n "${4}"
                then
                    echo "Variavel nivel: ${4}"
            else
                echo "Variavel nivel: Vazio"
                exit 0
            fi
    esac
fi

#Pegando o nivel de altitude
if test -n "${5}" #&& [[ "${5}" == "-r" || "${5}" == "--regiao" ]]
then
    case "${5}" in

        -r | --regiao) #A variavel regiao sendo identificada
            if test -n "${6}"
                then 
                    echo "Variavel regiao: ${6}"
            else
                echo "Variavel regiao: Vazio"
                exit 0
            fi
            ;;

        -ll | --lonlat)
            if test -n "${6}" && test -n "${7}"
                then
                    echo "Variavel regiao: ${6} ${7}"
            else
                echo "Variavel regiao: Vazio"
                exit 0      
            fi
    esac
   
fi

#Acessando o python

if [[ -n "${1}" ]] && [[ -n "${2}" ]] && [[ -n "${3}" ]] && [[ -n "${4}" ]] && [[ -n "${5}" ]] && [[ -n "${6}" ]]
then

    if [ -z "${7}" ]
    then
        cd ../classes_MET
        python3 regioes_MET.py "${1}" "${2}" "${3}" "${4}" "${5}" "${6}"
    else    
        cd ../classes_MET/
        python3 regioes_MET.py "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}"     
    fi

fi
   
#cd ../classes_MET/
#/home/phpimenta/anaconda3/bin/python3.8 
#python3 regioes_MET.py ${1} ${2} ${3} ${4} ${5} ${6}