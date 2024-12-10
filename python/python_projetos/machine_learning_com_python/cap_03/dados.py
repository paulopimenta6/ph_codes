import csv

def carregar_buscas():
    X = []
    Y = []

    with open('buscas.csv', 'r') as arquivo:
       leitor = csv.reader(arquivo)
       next(leitor)

       for home, busca, logado, comprou in leitor:
           dado = ([int(home), busca, int(logado)])
           X.append(dado)
           Y.append(int(comprou))

    return X, Y       
