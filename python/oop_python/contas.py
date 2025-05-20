class Conta:
    def __init__(self, clientes, numero, saldo = 0):
        self.saldo = 0
        self.clientes = clientes
        self.numero = numero
        self.operacoes = []
        self.deposito(saldo)

    def resumo(self):
        print(f"CC Numero: {self.numero} - Saldo: {self.saldo:10.2f}")

    def saque(self, valor):
        if self.saldo >= valor:
            self.saldo -= valor
            self.operacoes.append(["Saque", valor])

    def deposito(self, valor):
        self.saldo += valor
        self.operacoes.append(["Deposito", valor]) 

    def extrato(self):
        print(f"Extrato CC N: {self.numero}\n")
        for operacao in self.operacoes:
            print(f"{operacao[0]:10} {operacao[1]:10.2f}")
        print(f"\nSaldo: {self.saldo:10.2f}\n")    

class ContaEspecial(Conta):
    def __init__(self, clientes, numero, saldo = 0, limite = 0):
        super().__init__(clientes, numero, saldo)
        self.limite = limite
    def saque(self, valor):
        if self.saldo + self.limite >= valor:
            print("Em conta especial: " + str(self.saldo))
            self.saldo -= valor
            self.operacoes.append(["Saque", valor])            