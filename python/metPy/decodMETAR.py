from metar import Metar

class decodMetar:
    def __init__(self,codMETAR, metar):
        self.codMETAR=codMETAR
        self.metar=metar
        metarDecodif=" "

    def imprime_decodMetar(self):
        metarDecodif=Metar.Metar("METAR " + self.metar)
        print(metarDecodif.string())      
