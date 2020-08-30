#!/bin/bash -x

#########################################
### Autor: Paulo Pimenta              ###
### email: paulopimenta315@gmail.com  ###
#########################################

echo "####################################################"
echo "### Programa de compilacao de codigos em C/CPP   ###"
echo "####################################################"

mensagem_de_uso="$(basename "$0") [OPCOES]

	\n
	\n
	OPCOES
	\n
	\n       

	-h | --help	Mostra menu de ajuda \n
	-v | --versao	Mostra versão de software \n
	-c | --compila	codigo a ser compilado. Codigo deve ser passado como parametro \n
"

if test -n "${1}"
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
			
			if [ "${extensao}" = "c" ]
			then
				gcc ${2} -Wall -o -lm ${nome_executavel}
			
			elif [ "${extensao}" = "cpp" ]
			then
				g++ ${2} -Wall -o -lm ${nome_executavel}
			
			else
				echo "Formato desconhecido"
				exit 0
			fi
			;;       
	esac

elif test -z "${1}" 
then
	echo "Parametro vazio"
	echo -e ${mensagem_de_uso}
fi	

exit 0
