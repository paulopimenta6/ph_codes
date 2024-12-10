class Soma:
    def __init__(self, primeiroValor, segundoValor):
        self.primeiroValor=primeiroValor
        self.segundoValor=segundoValor
        self.resultado=None
     
    def soma(self):
        self.resultado=(self.primeiroValor+self.segundoValor)        
        return self.resultado


