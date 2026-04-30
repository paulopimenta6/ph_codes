from functools import total_ordering

@total_ordering

class TipoTelefone:
    def __initi__(self, tipo):
        self.tipo = tipo
    
    def __str__(self):
        return f"({self.tipo})"
    
    def __eq__(self, outro):
        if outro is None:
            return False
        else:
            return self.tipo == outro.tipo

    def __lt__(self, outro):
        if outro is None:
            return False
        else:
            return self.tipo < outro.tipo
