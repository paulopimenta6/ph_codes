#-*- coding:utf-8 -*-

lista_primos=[]
lista_nao_primos=[]

print "Determina se um numero n > 0 e primo"

# leia o valor de n
print "Digite o valor de n (n > 0): "
n = int(raw_input())

while n<0:
	print "O valor deve ser maior que 0, digite um numero > 0:"	
	n = int(raw_input())

while n >= 1:

	# n é primo até que se prove o contrário
	if n == 2 or (n != 1 and n % 2 == 1): # 2 é primo , 1 não é primo
		e_primo = True
	else:
		e_primo = False  # pares maiores que 2 não são primos

	# procure por um divisor ímpar de n entre 2 e n-1
	divisor = 3

	while divisor < n and e_primo: # equivalente a "div ... and é_primo == True:"
		if n % divisor == 0:
		    e_primo = False
		divisor += 2

	if e_primo: 
		lista_primos.append(n)
	else:
		lista_nao_primos.append(n)

	n -= 1

print "Os primos sao: %s: " %(lista_primos)
print "Os nao primos sao: %s: " %(lista_nao_primos)
