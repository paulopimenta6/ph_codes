#-*- coding:utf-8 -*'

print "Digite o valor do numero:"
n = float(raw_input())

while n <= 0:
    print "O numero deve ser maior que 0"
    print "Digite novamente!"
    n = float(raw_input())    

b = 2
cont = 1

print "#######################################################"
while True:
       p = (b + (n/b))/2
       n_outro = round((p*p), 6)
       diferenca = round(abs(n - n_outro), 6)                    
       print "%dº valor de \"p\", aproximacao e diferenca: %f, %f e %f" %(cont, p, n_outro, diferenca)
       if diferenca < 0.0001:
           print "Convergiu na rodada: %d e com a diferenca: %f" %(cont, diferenca)
	   break
       b=p
       cont = cont + 1 
