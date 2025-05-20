from clientes import Cliente
from contas import Conta, ContaEspecial
from bancos import Banco

###Criando clientes
Joao = Cliente("Joao Diogo", "777-1234")
Maria = Cliente("Maria da Silva", "555-4321")
Jose = Cliente("Jose Vargas", "712-0745")

###Criando Contas
conta1  = Conta([Joao], numero="001", saldo=1000)
conta2 = ContaEspecial(clientes=[Joao, Maria], numero="002", saldo=500, limite=1000)
conta3 = Conta([Jose], numero="003")

###Criando cadastro de bancos
itau = Banco("Itau")
BB = Banco("Banco do Brasil")
CEF = Banco("Caixa Economica Federal")

###Abrindo contas dos usuarios nos bancos
itau.abre_contas(conta1)
BB.abre_contas(conta2)
CEF.abre_contas(conta3)

###Realizando operacoes
conta1.saque(50)
conta1.saque(190)
conta2.deposito(300)
conta2.deposito(95.15)
conta2.saque(1500)
conta3.deposito(1000)
conta3.deposito(500)

###Extrato das contas
conta1.extrato()
conta2.extrato()
conta3.extrato()