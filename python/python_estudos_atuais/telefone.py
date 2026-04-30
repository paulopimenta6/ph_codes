class Telefone:
    
    def __init__(self, numero, tipo=None):
        self.numero = numero
        self.tipo = tipo

    def __str__(self):
        tipo = self.tipo or ""
        return f"{self.tipo} {tipo}"

    def __eq__(self, outro):
        return self.numero == outro.numero and (
            (self.tipo == outro.tipo) or (
             self.tipo is None or outro.tipo is None))

    @property
    def numero(self):
        return self.__numero

    @numero.setter
    def numero(self, valor):
        if valor is None or not valor.strip():
            raise ValueError("O número do telefone não pode ser vazio.")
        else:
            self.__numero = valor  
