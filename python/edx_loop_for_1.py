#-*- coding:utf-8 -*-

#Using a for loop, write a program which prints the sum of all the even numbers from 1 to 101. 
sum=0
for x in range (1,101):
    if x%2 == 0:
        sum = sum + x
print(sum)
