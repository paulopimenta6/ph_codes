import csv

def carregar_acessos():
    X = []
    Y = []
    file = open('acesso.csv', 'r')
    reader = csv.reader(file)

    next(file)
    for home, como_funciona, contato, comprou in reader:
        dados = [int(home), int(como_funciona), int(contato)]
        X.append(dados)
        Y.append(int(comprou))

    return X, Y