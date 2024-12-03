# A biblioteca numpy

## Introdução 

A biblioteca numpy e um importante recurso para manipulacao de matrizes em Python diminuindo a quantidade de linhas de códigos e agilizando a rapizes em operações matemáticas

1. Importando a biblioteca numpy 
Tudo se inicia com a importação da biblioteca no python por meio do comando:

```python
import numpy as np
```

ou

```python
import numpy 
```

Aqui será preciso usar o operador ponto, pois os métodos foram importados integralmente para uso. Exemplo:
```python
np.linalg.inv()
np.matrix([])
```
ou

```python
numpy.linalg.inv()
numpy.matrix([])
```

2. Selecionando os elementos (métodos que serão usados)

Esta é uma maneira de conseguir filtrar de forma segura quais métodos usar e não gastar recursos de forma desnecessária.

```python 
from numpy import matrix
```

```python
from numpy import zeros, ones, identity
```

E assim por diante.

3. Casos de uso

#### Criando uma matriz