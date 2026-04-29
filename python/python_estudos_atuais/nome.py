from functools import total_ordering

@total_ordering
class Nome:
    def __init__(self, nome):
        if nome is None or not nome.strip():
            raise ValueError("Nome nao pode ser nulo nem em branco")
        self.nome = nome
        self.chave = nome.strip().lower()

    def __str__(self):
        return self.nome

    def __repr__(self):
        return f"<Classe {type(self).__name__} em 0x{id(self):x} Nome: {self.nome} Chave: {self.chave}>"
    
    def __eq__(self, outro):
        print("__eq__ Chamado")
        return self.nome == outro.nome

    def __lt__(self, outro):
        print("__lt__ Chamado")
        return self.nome < outro.nome
    
    @staticmethod
    def CriaChave(nome):
        return nome.strip().lower()
            
