#-*- coding:utf-8 -*-

##################################################
#Paulo Pimenta - paulopimenta@315@gmail.com     ##
#...             paulo.pimenta@usp.br           ##
#                                               ##
##################################################  

while True:

	print "Este e um programa que faz divisoes usando soma e subtracao"
	print "Digite um valor inteiro"
	valor = int(raw_input())
	
	print "Deseja dividir por quanto?"
	divisor = int(raw_input())
	
	while divisor > valor:
		print "O divisor e maior que o valor a ser divido!"
		print "deseja alterar o divisor ou o valor?"
		print "Digite \"d\" ou \"D\" para digito ou \"v\" ou \"V\" para valor"
		resposta = str(raw_input())
		
		if resposta == "d" or resposta == "D":
			print "Digite um divisor novo: "
			divisor = int(raw_input())
		
		elif resposta == "v" or resposta == "V":
			print "Digite um valor novo: "
			valor = int(raw_input())

		else:
			if type(resposta) != str:
				print "Resposta invalida. Tente novamente!"

	
	quociente = 0
	contador = 0
	while valor > quociente: #Verificar isso depois!!
		quociente = quociente + divisor
		contador = contador + 1
	
	resto = valor - quociente	
	if resto == 0:
		divisao_exata = True
	else:
		divisao_exata = False	
	   
	if divisao_exata:
		print "A divisao e exata e o resto e: %d e o valor do quociente e: %d" %(resto, quociente)
	else:
		print "A divisao nao e exata e o resto e: %d e o valor do quociente e: %d" %(resto, quociente)

	print "Deseja continuar? s/S ou n/N"
        resposta_2 = str(raw_input())
	if resposta_2 != "s" or resposta_2 != "S":
		break
