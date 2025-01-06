# -*- coding: utf-8 -*-

### Bootstrap - Os resultados podem variar devido... 
### ...a aleatoriedade da amostragem

from sklearn.utils import resample 

### Amostra
amostra = [1, 2, 3, 4, 5, 6, 7]

### Gerando 5 subamostras de tamanho 4
for i in range(1,6):
    subamostra = resample(amostra, replace = True, n_samples=4)
    
    print(f'Subamostra {i} com bootstrap: {subamostra}')
    ### Observacoes out of bag
    oob = [x for x in amostra if x not in subamostra]
    print(f'Obseravoes OOB para {i}: {oob}')