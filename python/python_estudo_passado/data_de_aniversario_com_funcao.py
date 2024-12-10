#!/usr/bin/env python2
# -*- coding: utf-8 -*-
from datetime import date

def deixaEntrar(data_nascimento_usuario, censura):

	dia_aniversario_usuario, mes_aniversario_usuario, ano_aniversario_usuario = data_nascimento_usuario.split("/") #Pegando a data de aniversário do usuário

	dia_aniversario_usuario = int(dia_aniversario_usuario) 
	mes_aniversario_usuario = int(mes_aniversario_usuario)
	ano_aniversario_usuario = int(ano_aniversario_usuario)
	censura = int(censura)
	
	data_atual = date.today()
	dia_atual = data_atual.day
	mes_atual = data_atual.month
	ano_atual = data_atual.year	
	
	#######################################################################
	#Aqui sera avaliado se o usuario podera ou nao ir ao cinema
	#E preciso verificar em primeiro lugar o mes e depois o ano para saber se o usuario faz aniversario antes ou depois da data atual
	
	idade_usuario = ano_atual - ano_aniversario_usuario
	if idade_usuario==censura:
		if mes_aniversario_usuario <= mes_atual:
			if dia_aniversario_usuario <= dia_atual:
				return True
				#"Parabéns! Hoje é seu aniversário! \n"
				#"Seu acesso esta liberado! O filme pode ser visto por você!"							
			else:
				quantidade_de_dias_aniversario = dia_aniversario_usuario - dia_atual
				return False  
				#"Faltam %d dias para você fazer aniversário! Seu acesso foi negado" %quantidade_de_dias_aniversario					
		else:
			quantidade_de_meses_aniversario = mes_aniversario_usuario - mes_atual
			return False 
			#"Em %d meses você vai fazer aniversário! Seu acesso foi negado" %quantidade_de_meses_aniversario
	else:
		if idade_usuario<censura:
			quantidade_de_anos_aniversario = censura - idade_usuario
			return False 		
			#"Em %d ano[s] você vai fazer aniversário! Seu acesso foi negado" %quantidade_de_anos_aniversario
		else:
			return True
			#"Acesso lberado!"

###################################################################################################
#Aqui é onde iremos pegar a data de nascimento do usuário e a idade minima para assistir o filme ##
###################################################################################################

print("#############################################################")
print("################ Bem vindo ao cinema 3DMAX ##################")
print("#############################################################")
data=raw_input("Informe a data de nascimento: dd/mm/yyyy \n")
idade_minima=raw_input("Informe a idade minima para assistir o filme: ")
print("###############################################################")
if deixaEntrar(data, idade_minima) == True:
	print("Acesso liberado!")
else:
	print("Acesso negado!")
