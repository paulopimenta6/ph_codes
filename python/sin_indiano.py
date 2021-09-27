from math import factorial
def my_sin(x):
    sign = -1
    p = 1
    d = 1
    i = sinx = 0
    while d > 0.0000000001: 
        d = (x**p)/float(factorial(p))
        sinx += ((sign**i)*d)
        i+=1
        p+=2
    return sinx

print "Digite um valor"
valor=float(raw_input())
a=my_sin(valor)
print(a)

