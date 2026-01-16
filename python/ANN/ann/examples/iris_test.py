import csv
from typing import List
from Core.util import normalize_by_feature_scaling
from Core.network import Network
from random import shuffle

if __name__=="__main__":
    # Listas para armazenar os dados do conjunto Iris
    iris_parameter: List[List[float]] = []
    iris_classifications: List[List[float]] = []
    iris_species: List[str] = []

    # Carrega o conjunto de dados Iris do arquivo CSV
    with open('data/iris.csv', mode = 'r') as iris_file:
        irises: List = list(csv.reader(iris_file)) # Le todas as linhas do arquivo CSV
        shuffle(irises) # Embaralha as linhas para garantir aleatoriedade
        for iris in irises:
            parameters: List[float] = [float(n) for n in iris[0:4]]
            iris_parameter.append(parameters) # Adiciona os parametros da flor
            species: str = iris[4]
            if species == "Iris-setosa":
                iris_classifications.append([1.0,0.0,0.0]) # One-hot encoding para Iris-setosa
            elif species == "Iris-versicolor":
                iris_classifications.append([0.0,1.0,0.0]) # One-hot encoding para Iris-versicolor
            else:
                iris_classifications.append([0.0,0.0,1.0]) # One-hot encoding para Iris-virginica
            iris_species.append(spencies) # Armazena o nome da especie
    normalize_by_feature_scaling(iris_parameter) # Normaliza os parametros usando feature scaling