class Banco:
    def __init__(self, nome):
        self.nome = nome
        self.contas = []
    def abre_contas(self, conta):
        self.contas.append(conta)
    def lista_contas(self):
        for c in self.contas:
            c.resumo()        