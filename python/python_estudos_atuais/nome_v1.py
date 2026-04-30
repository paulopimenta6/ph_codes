from functools import total_ordering

@total_ordering
class Nome:
    def __init__(self, nome):
        self.nome = nome
    
    def __str__(self):
        return self.nome
    
    def __repr__(self):
        return f"<Classe {type(self).__name__} em 0x{id(self):x} Nome: {self.__nome} Chave: {self.__chave}>"
    
    def __eq__(self, outro):
        return self.nome == outro.nome

    def __lt__(self, outro):
        return self.nome < outro.nome
    
    @property
    def nome(self):
        return self.__nome

    @property
    def chave(self):
        return self.__chave   
    
    @nome.setter
    def nome(self, valor):
        if valor is None or not valor.strip():
            raise ValueError("Nome nao pode ser nulo nem em branco")
        else:
            self.__nome = valor

    @chave.setter
    def chave(self, valor):
        if valor is None or not valor.strip():
            raise ValueError("Chave nao pode ser nulo nem em branco")
        else:
            self.__chave = valor        
    
    @staticmethod
    def CriaChave(nome):
        return nome.strip().lower()