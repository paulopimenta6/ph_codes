#-*- coding:utf-8 -*-

#Exercicio do curso de python do edx
#Usa-se Python3
#Write a program using while loop, which asks the user to type a positive integer, n, and then prints the factorial of n. A factorial is defined as the product of all the numbers from 1 to n (1 and n inclusive). For example factorial of 4 is equal to 24. (because 1*2*3*4=24)

number = int(input("write a number: "))
if number < 0:
    print("number must be a positive number!")
else:
    aux=1
    factorial=number
    while aux < number:
        factorial = factorial*(aux)
        aux = aux+1
print(factorial)
