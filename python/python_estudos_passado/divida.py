# -*- coding: utf-8 -*-

print "Digite o valor da divida: "
divida = float(raw_input())

print "Digite o valor do juros ao mes: "
juros = float(raw_input())

print "Digite o valor que deseja para sua parcela: "
parcela = float(raw_input())

n_parcelas = int(divida/parcela)

saldo = 0
parcela_juros = 0
mes = 1
total_pago = 0

while mes <= n_parcelas:    
    parcela_juros = parcela_juros + (divida*(juros/100))
    divida = divida - parcela
    total_pago = total_pago + (parcela_juros + parcela)
    mes = mes + 1

print "Serao acrescidos juros"
print "O valor total dos juros, o valor da divida total e o numero de parcelas sao: %.2f %.2f %d" %(parcela_juros, total_pago, n_parcelas)    