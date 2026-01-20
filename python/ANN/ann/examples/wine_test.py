import csv
from typing import List
from ..Core.util import normalize_by_feature_scaling
from ..Core.network import Network
from random import shuffle

if __name__=="__main__":
    # Listas para armazenar os dados do conjunto Wine
    wine_parameters: List[List[float]] = []
    wine_classifications: List[List[float]] = []
    wine_species: List[int] = []
    with open('ann/data/wine.csv', mode ='r') as wine_file:
        wines: List = list(csv.reader(wine_file, quoting=csv.QUOTE_NONNUMERIC))
        shuffle(wines) # Deixa as linhas em ordem aleatoria
        for wine in wines:
            # Le cada linha sequencialmente ate o penultimo elemento e adiciona os dados na lista
            parameters: List[float] = [float(n) for n in wine[1:14]] 
            # Adiciona os parametros do vinho na lista wine_parameters
            wine_parameters.append(parameters)
            species: int = int(wine[0])
            if species == 1:
                wine_classifications.append([1.0,0.0,0.0]) # One-hot encoding para a classe 1
            elif species == 2:
                wine_classifications.append([0.0,1.0,0.0]) # One-hot encoding para a classe 2
            else:
                wine_classifications.append([0.0,0.0,1.0]) # One-hot encoding para a classe 3
            wine_species.append(species) # Armazena o numero da classe do vinho extraido da primeira coluna
    
    # Normaliza os parametros dos dados do vinho evitando possiveis problemas no treinamento
    normalize_by_feature_scaling(wine_parameters) 
    # Cria a rede neural com 13 entradas, 7 neuronios na camada oculta, 3 saidas e taxa de aprendizado de 0.9
    wine_network: Network = Network([13, 7, 3], 0.9)

    # Interpreta a saida da rede neural retornando a classe do vinho
    # Retorna 1, 2 ou 3 dependendo do indice do maior valor na lista de saida 
    def wine_interpret_output(output: List[float]) -> int:    
        if max(output) == output[0]:
            return 1
        elif max(output) == output[1]:
            return 2
        else:
            return 3

    # Treina a rede neural com os primeiros 150 dados do conjunto de vinhos, 10 vezes
    wine_trainers: List[List[float]] = wine_parameters[0:150]
    wine_trainers_corrects: List[List[float]] = wine_classifications[0:150]
    for _ in range(10):
        wine_network.train(wine_trainers, wine_trainers_corrects)

    # Testa a rede neural com os ultimos 28 dados do conjunto de vinhos
    wine_testers: List[List[float]] = wine_parameters[150:178]
    wine_testers_corrects: List[int] = wine_species[150:178]
    wine_results = wine_network.validate(wine_testers, wine_testers_corrects, wine_interpret_output)
    print(f"{wine_results[0]} correct of {wine_results[1]} = {wine_results[2]*100}%")    