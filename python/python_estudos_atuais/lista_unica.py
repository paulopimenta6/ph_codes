class ListaUnica:
   
    def __init__(self, elem_classe):
        self.lista = []
        self.elem_classe = elem_classe

    def __len__(self):
        return len(self.lista)

    def __iter__(self):
        return iter(self.lista)

    def __getitem__(self, posicao):
        return self.lista[posicao]

    def indiceValido(self, indice):
        return indice >= 0 and indice < len(self.lista)

    def adiciona(self, elem):
        if self.pesquisa(elem)  == -1:
            self.lista.append(elem)

    def remove(self, elem):
        self.lista.remove(elem)

    def pesquisa(self, elem):
        self.verifica_tipo(elem)
        try:
            return self.lista.index(elem)
        except ValueError:
            return -1
        
    def verifica_tipo(self, elem):
        if not isinstance(elem, self.elem_classe):
            raise TypeError("Tipo invalido")
        
    def ordena(self):
        self.lista.sort()





