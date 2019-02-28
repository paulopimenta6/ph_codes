#-*-coding:utf-8-*-

#####################################################
#Programa usado para verificacao de palindromos     #
#Paulo Pimenta - paulopimenta315@gmail.com ...      #  
#... paulo.pimenta@usp.br                           #
#                                                   #
#####################################################

print "Programa que verifica se o numero e um palindromo"
print "Palindromos sao numero que caso invertido sao iguais a si mesmos"
print "454 e um palindromo"
print "123 nao e um palindromo"

print "..."

print "Digite um numero: "
numero = int(raw_input())

while type(numero) != int:
	print "Digite um numero: "
	numero = int(raw_input())

e_palindromo = True

if numero < 0:
	print "Numero negativo! Entao vamos tirar o sinal de menos!"
	numero = str(numero)
	numero = numero[1:]
	numero = int(numero) 

if numero >= 0:
	numero = str(numero)
	if len(numero)%2 == 0:
		i=0		
		while i <= (len(numero)/2):
			if numero[i] == numero[(len(numero)-1)-i]: #o tamanho de uma lista vai até (tamanho total - 1)
		        	i = i + 1
			else:
		                e_palindromo = False
				break
	else:
		termo_do_meio = (len(numero)/2) + (int(numero)%2)	
		i=0
		while i < termo_do_meio:
			if numero[i] == numero[(len(numero)-1)-i]:
		        	i = i + 1
			else:
		                e_palindromo = False
				break
numero = int(numero)
if e_palindromo == True:
	print "O numero %d e palindromo" %(numero)
else:
	print "O numero %d nao e palindromo" %(numero)
