#!/bin/bash

#########################################
### Autor: Paulo Pimenta              ###
### email: paulopimenta315@gmail.com  ###
#########################################

echo "####################################################"
echo "### Programa de compilacao de codigos em C/CPP   ###"
echo "####################################################"

mensagem_de_uso="$0 [-h | -v | -c]
      
      -h    Mostra menu de ajuda
      -v    Mostra versão de software
      -c    codigo a ser compilado
"

case "${1}" in

	-h)
		echo ${mensagem_de_uso}
		exit 0
		
	;;

	-v)
		echo "Versao 1.0"
		exit 0

	;;

	-c)
		echo "Insira o nome do arquivo a ser compilado (.c ou .cpp)"
		echo "Exemplo: ./make.sh codigo.c"
		exit 0

	;;       




exit 0
