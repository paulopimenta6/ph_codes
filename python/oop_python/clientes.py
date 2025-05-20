class Cliente:
    def __init__(self, nome, telefone):
        self.nome = nome
        self.telefone = telefone

    def __repr__(self):
        return f"Nome: {self.nome} - Telefone: {self.telefone}"      