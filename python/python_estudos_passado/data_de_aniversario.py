#!/usr/bin/env python2
# -*- coding: utf-8 -*-
from datetime import date

#######################################################################
#O usuario ira informar a data de nascimento no formato dd/mm/yyyy

data=raw_input("Informe a data de nascimento: dd/mm/yyyy \n")
dia_aniversario_usuario, mes_aniversario_usuario, ano_aniversario_usuario = data.split("/") #Pegando a data de aniversário do usuário

dia_aniversario_usuario = int(dia_aniversario_usuario) 
mes_aniversario_usuario = int(mes_aniversario_usuario)
ano_aniversario_usuario = int(ano_aniversario_usuario)

#######################################################################
#Aqui e preciso pegar as datas que o sistema prove ao usuario
#Devemos lembrar que linguagens em script possuem isso pronto

data_atual = date.today()
print("\n")
print("A data atual é: data_atual %s" %data_atual) #Pegando a data do sistema
dia_atual = data_atual.day
mes_atual = data_atual.month
ano_atual = data_atual.year

#######################################################################
#Aqui sera avaliado se o usuario podera ou nao ir ao cinema
#E preciso verificar em primeiro lugar o mes e depois o ano para saber se o usuario faz aniversario antes ou depois da data atual

idade_ano = ano_atual - ano_aniversario_usuario
if idade_ano==18:
	if mes_aniversario_usuario <= mes_atual:
		if dia_aniversario_usuario <= dia_atual:
			print("Parabéns! Hoje é seu aniversário! \n")
			print("Seu acesso esta liberado! Você é maior de idade!")			
		else:
			quantidade_de_dias_aniversario = dia_aniversario_usuario - dia_atual  
			print("Faltam %d dias para você fazer aniversário! Seu acesso foi negado" %quantidade_de_dias_aniversario)	
	else:
		quantidade_de_meses_aniversario = mes_aniversario_usuario - mes_atual 
		print("Em %d meses você vai fazer aniversário! Seu acesso foi negado" %quantidade_de_meses_aniversario)
else:
	if idade_ano<18:
		quantidade_de_dias_aniversario = dia_aniversario_usuario - dia_atual
		quantidade_de_meses_aniversario = mes_aniversario_usuario - mes_atual
		quantidade_de_anos_aniversario = 18 - (ano_atual - ano_aniversario_usuario) 		
		print("Em %d ano[s], %d mes[es] e %d dia[s] você vai fazer aniversário! Seu acesso foi negado" %(quantidade_de_anos_aniversario, quantidade_de_meses_aniversario, quantidade_de_dias_aniversario))
	else:
		print("Acesso lberado!")
