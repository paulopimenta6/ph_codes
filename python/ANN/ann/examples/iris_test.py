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