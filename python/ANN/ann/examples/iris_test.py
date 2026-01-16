import csv
from typing import List
from ..Core.util import normalize_by_feature_scaling
from ..Core.network import Network
from random import shuffle

if __name__=="__main__":
    # Listas para armazenar os dados do conjunto Iris
    iris_parameters: List[List[float]] = []
    iris_classifications: List[List[float]] = []
    iris_species: List[str] = []

    # Carrega o conjunto de dados Iris do arquivo CSV
    with open('data/iris.csv', mode = 'r') as iris_file:
        irises: List = list(csv.reader(iris_file)) # Le todas as linhas do arquivo CSV
        shuffle(irises) # Embaralha as linhas para garantir aleatoriedade
        for iris in irises:
            parameters: List[float] = [float(n) for n in iris[0:4]]
            iris_parameters.append(parameters) # Adiciona os parametros da flor
            species: str = iris[4]
            if species == "Iris-setosa":
                iris_classifications.append([1.0,0.0,0.0]) # One-hot encoding para Iris-setosa
            elif species == "Iris-versicolor":
                iris_classifications.append([0.0,1.0,0.0]) # One-hot encoding para Iris-versicolor
            else:
                iris_classifications.append([0.0,0.0,1.0]) # One-hot encoding para Iris-virginica
            iris_species.append(spencies) # Armazena o nome da especie
    normalize_by_feature_scaling(iris_parameters) # Normaliza os parametros usando feature scaling
    iris_network: Network = Network([4,6,3], 0.3) # Cria a rede neural com 4 entradas, 6 neuronios na camada oculta e 3 saidas

    def iris_interpret_output(output: List[float]) -> str:
        if max(output) == output[0]:
            return "Iris-setosa"
        elif max(output) == output[1]:
            return "Iris-versicolor"
        else:
            return "Iris-virginica"

    # Faz o treinamento com os 140 primeiros dados de amostras de iris do conjunto, 50 vezes
    iris_trainers: List[List[float]] = iris_parameters[0:140]
    iris_trainers_corrects: List[List[float]] = iris_classifications[0:140]

    for _ in range(50):
        iris_network.train(iris_trainers, iris_trainers_corrects)

    # Teste nos 10 ultimos dados da amostra de iris do conjunto
    iris_trainers: List[List[float]] = iris_parameters[140:150]
    iris_testers_corrects: List[str] = iris_species[140:150]
    iris_results = iris_network.validate(iris_testers, iris_testers_corrects, iris_interpret_output)

    print(f"{iris_result[0]} correct of {iris_results[1]} = {iris_results[2]*100}%")               


