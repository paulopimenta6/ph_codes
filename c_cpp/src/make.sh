#!/bin/bash

#########################################
### Autor: Paulo Pimenta              ###
### email: paulopimenta315@gmail.com  ###
#########################################

echo "####################################################"
echo "### Programa de compilacao de codigos em C/CPP   ###"
echo "####################################################"

mensagem_de_uso="$(basename "$0") [OPCOES]
	
	OPCOES       

	-h | --help	Mostra menu de ajuda
	-v | --versao	Mostra versão de software
	-c | --compila	codigo a ser compilado. Codigo deve ser passado como parametro
"

if test -n ${1}
then	
	case "${1}" in

		-h | --help)
			echo ${mensagem_de_uso}
			exit 0
			;;

		-v | --versao)
			echo "Versao 1.0"
			exit 0
			;;

		-c | --compila)

			nome_executavel=$(echo "${2}" | cut -d . -f 1)
			extensao=$(echo "${2}" | cut -d . -f 2)
			
			if ["${extensao}" = 'c']
			then
				gcc ${2} -Wall -o ~/bin/${nome_executavel}
			
			elif ["${extensao}" = 'cpp']
			then
				g++ ${2} -Wall -o ~/bin/${nome_executavel}
			
			else
				echo "Formato desconhecido"

			fi
	
			exit 0
			;;       
	esac

else
	echo "Parametro vazio"
	echo ${mensagem_de_uso}

fi	

exit 0
