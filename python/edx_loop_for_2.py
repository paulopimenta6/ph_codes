#Using a for loop, write a program which asks the user to type an integer, n, and then prints the sum of all numbers from 1 to n (including both 1 and n).
number = int(input("write a number: "))
sum=0
for i in range(1,number+1):
    sum = sum + i

print(sum)
