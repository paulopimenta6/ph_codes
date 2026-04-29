from collections import UserList

class ListaUnica(UserList):
    def __init__(self, elem_classe, enumerable=None):
        super().__init__(enumerable)
        self.elem_classe = elem_classe

    def append(self, elem):
        self.verifica_tipo(elem)
        if elem not in self.data:
            super().append(elem)

    def __setitem__(self, posicao, elem):
        self.verifica_tipo(elem)
        if elem not in self.data:
            super().__setitem__(posicao, elem)

    def verifica_tipo(self, elem):
        if not isinstance(elem, self.elem_classe):
            raise TypeError("Tipo invalido")
                            