import numpy as np
from  sklearn.model_selection import cross_val_score
from scipy import stats

### Conjunto de dados e um modelo de classificacao
from sklearn.datasets import load_iris
from sklearn.tree import DecisionTreeClassifier

### Realizando a validacao cruzada com 5 folhas
def cross_validation(x, y, clf):
    scores = cross_val_score(estimator=clf, X=x, y=y, scoring='accuracy', cv=5)
    return scores

def mean_score(scores):
    return np.mean(scores)

def standard_deviation_score(scores):
    return np.std(scores)

def confidence_interval(scores):
    return stats.t.interval(0.95, len(scores)-1, loc=np.mean(scores), scale=stats.sem(scores))

### Carregando o conjunto de dados
iris = load_iris()
x = iris.data
y = iris.target

### Criando modelo
clf = DecisionTreeClassifier()

ans_scores = cross_validation(x, y, clf)
ans_mean = mean_score(ans_scores)
ans_std = standard_deviation_score(ans_scores)
ans_IC = confidence_interval(ans_scores)

print(f'Media: {ans_mean:.2f}')
print(f'Desvio Padrao: {ans_std:.2f}')  
print(f'Intervalo de Confianca: ({ans_IC[0]:.2f}, {ans_IC[1]:.2f})')