#-*- coding:utf-8 -*-

#Exercicio do curso de python do edx
#Usa-se Python3
#Write a program which prints the sum of numbers from 1 to 101 that are divisible by 5. ( 1 and 101 are included) (Use while loop)

value=1
aux=0

while value < 102:
    if value%5 == 0:
        aux = aux + value     
    value = value + 1
print(aux)
    
