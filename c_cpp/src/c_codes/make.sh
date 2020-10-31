#!/usr/bin/env bash

#########################################
### Autor: Paulo Pimenta              ###
### email: paulopimenta315@gmail.com  ###
#########################################

####################################################
### Programa de compilacao de codigos em C/CPP   ###
####################################################

dir_binario="../../bin/"

mensagem_de_uso="$(basename "$0") [OPCOES]

	OPCOES:	   

	-h | --help	Mostra menu de ajuda \n
	-v | --versao	Mostra versão de software \n
	-c | --compila	codigo a ser compilado. Codigo deve ser passado como parametro \n
"

############################################################
### Aqui sera avaliado se o diretorio de binarios existe ###
############################################################

if [ -d "${dir_binario}" ] 
then
	echo "O diretorio existe"
else
	echo "O diretorio nao existe vamos criar o diretorio"
	mkdir "${dir_binario}"
	echo "A diretorio ${dir_binario} foi criado"
fi

if test -n "${1}"
then	
	case "${1}" in

		-h | --help)
			echo -e "${mensagem_de_uso}"
			exit 0
			;;

		-v | --versao)
			echo "Versao 2.0"
			exit 0
			;;

		-c | --compila)

		if test -n "${2}"
		then			
			nome_executavel=$(echo "${2}" | cut -d . -f 1)
			extensao=$(echo "${2}" | cut -d . -f 2)
			
			if [ "${extensao}" = "c" ]
			then
				gcc ${2} -lm -Wall -o "${dir_binario}""${nome_executavel}"
				echo "Compilacao concluida!"
				echo "Diretorio de binarios:"
				ls "${dir_binario}" 
			
			elif [ "${extensao}" = "cpp" ]
			then
				g++ ${2} -lm -Wall -o "${dir_binario}""${nome_executavel}"
				echo "Compilacao concluida!"
				echo "Diretorio de binarios: "
				ls "${dir_binario}"
			else
				echo "Formato desconhecido"
				exit 1
			fi
		else
			echo -e "Falta o argumento de compilacao"
			echo -e "Nao esqueca que e: ./make.sh -c | --compila <codigo.c/codigo.cpp>"
			exit 1
		fi

			;;       
	esac

else
	echo "Parametro vazio"
	echo -e "${mensagem_de_uso}"
fi	

exit 0
