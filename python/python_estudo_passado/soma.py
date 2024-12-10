#-*- coding: utf8 -*- 

print"Digite um numero: "
primeiro_valor = int(raw_input())
print"Digite um outro numero: "
segundo_valor = int(raw_input())
soma=primeiro_valor+segundo_valor
print"O resultado e: %d" %(soma) 

print"Digite uma medida: "
media = float(raw_input())
medida_mm=media*1000
print"O resultado em mm: %.2f" %(medida_mm)

print"Digite uma quantidade em horas"
horas=int(raw_input())
print"Digite uma quantidade em minutos"
minutos=int(raw_input())
print"Digite uma quantidade em segundos"
segundos=int(raw_input())
total_segundos=(3600*horas)+(60*minutos)+(segundos)
print"O tempo total em segundos: %d" %(total_segundos)
