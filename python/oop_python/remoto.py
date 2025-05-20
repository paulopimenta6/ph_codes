class Televisao:
    def __init__(self, canal_min, canal_max):
        self.__ligada = False
        self.__canal = 2
        self.canal_min = canal_min
        self.canal_max = canal_max

    @property
    def ligada(self):
        return self.__ligada

    @ligada.setter
    def ligada(self, estado):
        self.__ligada = estado    

    @property
    def canal(self):
        return self.__canal

    @canal.setter
    def canal(self, novoCanal):
        if self.ligada:
            if self.canal_min <= novoCanal <= self.canal_max:
                self.__canal = novoCanal        
    
    def muda_canal_para_baixo(self):
        if self.ligada:
            if self.__canal - 1 >= self.canal_min:
                self.__canal -= 1

    def muda_canal_para_cima(self):
        if self.ligada:
            if self.__canal + 1 <= self.canal_max:
                self.__canal += 1

class Pilha:
    def __init__(self, energia=100):
        self.energia = energia
    
    def consuma(self, consumo):
        if consumo > self.energia:
            consumo = self.energia
        else:
            self.energia -= consumo
        return consumo    

class ControleRemoto:
    def __init__(self, televisao, pilha):
        self.televisao = televisao
        self.pilha = pilha

    def liga(self):
        if self.pilha.consuma(1):
            self.televisao.ligada = True

    def desliga(self):
        if self.pilha.consuma(1):
            self.televisao.ligada = False

    def canal_mais(self):
        if self.pilha.consuma(1) and self.televisao.ligada:
            self.televisao.muda_canal_para_cima()        

    def canal_menos(self):
        if self.pilha.consuma(1) and self.televisao.ligada:
            self.televisao.muda_canal_para_baixo()