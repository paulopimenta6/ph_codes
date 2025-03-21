# A biblioteca numpy

## Introdução 

A biblioteca numpy e um importante recurso para manipulacao de matrizes em Python diminuindo a quantidade de linhas de códigos e agilizando a rapizes em operações matemáticas

A instalação é feita da seguinte forma:

- pip install numpy
- pip3 install numpy
- conda install numpy

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

É possível realizar arredondamentos e castings de matrizes

```python
# Aqui uma nova matriz foi criada sendo realizado um casting, ou seja, mudança de tipo de int para float com uma casa decimal.
matriz_B = round(matrix(matriz_A*matriz_A_inv, dtype='float'), decimals=1)
```

- A matriz transposta 

```python
matriz_A = matrix([
    [7,2,4],
    [3,5,9]
])
matriz_A_t = transpose(matriz_A)
# A resposta deve ser:
# [7, 3]
# [2, 5]
# [4, 9]
``` 

- Matriz inversa 

```python
matriz_A = matrix([
    [7,2,4],
    [3,5,9],
    [1,6,8]
])
### Criacao da matriz inversa de A
matriz_A_inv = linalg.inv(matriz_A)
```

- Valores máximos e mínimos

```python
matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9] 
])
# Identificar o maior e o menor valor da matriz A 
maior_valor_A = matriz_A.max()
menor_valor_A = matriz_A.min()
```
ou

```python
matriz_A = matrix([
    [7, 2, 4],
    [3, 5, 9] 
]) 
maior_valor_A = matriz_A.max(axis = 0) #identifica os maiores valores por coluna
menor_valor_A = matriz_A.min(axis = 1) #identifica os menores valores por linha
# axis = 0 indica a coluna
# axis = 1 indica a linha
```