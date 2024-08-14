def fatorial(numero_int): 
    n = 1
    fatoriaal = numero_int
    if fatoriaal == 1:
        return 1
    else:
	while n<numero_int:
	    fatoriaal = fatoriaal*(numero_int-n)
	    n = n + 1
	return long(fatoriaal) 

print"Digite um valor"
valor=int(raw_input())
a=fatorial(valor)
print(type(a))
print(a)
