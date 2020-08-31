#!/bin/bash

#########################################
### Autor: Paulo Pimenta              ###
### email: paulopimenta315@gmail.com  ###
#########################################

echo "####################################################"
echo "### Programa de compilacao de codigos em C/CPP   ###"
echo "####################################################"

mensagem_de_uso="$(basename "$0") [OPCOES]

	OPCOES:	   

	-h | --help	Mostra menu de ajuda \n
	-v | --versao	Mostra versão de software \n
	-c | --compila	codigo a ser compilado. Codigo deve ser passado como parametro \n
"

if test -n "${1}"
then	
	case "${1}" in

		-h | --help)
			echo -e "${mensagem_de_uso}"
			exit 0
			;;

		-v | --versao)
			echo "Versao 1.0"
			exit 0
			;;

		-c | --compila)
		if test -n "${2}"
		then			
			nome_executavel=$(echo "${2}" | cut -d . -f 1)
			extensao=$(echo "${2}" | cut -d . -f 2)
			
			if [ "${extensao}" = "c" ]
			then
				gcc ${2} -lm -Wall -o -lm ../bin/"${nome_executavel}"
				echo "Compilacao concluida!"
				ls ../bin/"${nome_executavel}" 
			
			elif [ "${extensao}" = "cpp" ]
			then
				g++ ${2} -lm -Wall -o -lm ../bin/${nome_executavel}
				echo "Compilacao concluida!"
				ls ../bin/"${nome_executavel}"
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

rm ./'--library=m'

exit 0
