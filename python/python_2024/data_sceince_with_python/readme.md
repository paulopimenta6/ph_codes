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

A criação de uma matriz é o primeiro passo no uso do numpy e se faz de formas bem simples.

- Criando uma matriz simples:
```python
matriz_A = matrix([
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
])
# Aqui o tipo da matriz já é inferiado diretamente pela linguagem
```

- Criando matrizes especiais
Primeiramente sera preciso fazer a importação de métodos especiais:

```python
from numpy import zeros, ones, identity
```
```python
# matriz de zeros
matriz_C = zeros((4,3), dtype='int')
```
```python
# matriz com valores em ponto flutuante
matriz_D = ones((2,3), dtype = 'float')
```

```python
# Produto de uma matriz de uns por 5
matriz_E = 5*ones((4,2), dtype='float')
```

```python
# matriz identidade 3x3
matriz_F = identity(3)
```