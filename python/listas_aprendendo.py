#-*- coding:utf-8 -*-

l=range(100)
i=range(101,201)
novo=[]

if len(l)==len(i):
	for t in range(len(l)):
		novo.append(l[t] + i[t])
		print(novo)
		print(t)		
		novo.pop(0)
		
#print"*******"
#print(novo)
#print"*******"
#print"+++++++++"

 
