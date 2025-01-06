from numpy import array
from sklearn.model_selection import KFold

### amostra 
amostra = array([1,2,3,4,5,6,7])

### Preparacao para validacao cruzada
kfold = KFold(n_splits=3, shuffle=True, random_state=7)

#### Folds gerados
for train, test in kfold.split(amostra):
    print(f'Treino: {amostra[train]} e Teste: {amostra[test]}')