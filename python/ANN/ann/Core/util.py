from typing import List
from math import exp

# Funcao para calcular o produto escalar entre dois vetores
# Definicao: https://en.wikipedia.org/wiki/Dot_product
def dot_product(xs: List[float], ys: List[float]) -> float:
    """Faz o produto escalar entre dois vetores."""
    return sum(x*y for x, y in zip(xs, ys))

# Sera usada uma funcao de ativacao da rede neural. 
# Sera usada a uma funcao sigmoide, cujo objetivo e mapear qualquer valor real para o intervalo entre 0 e 1.
# Mais detalhes podem ser vistos em: 
# [1] https://pt.wikipedia.org/wiki/Fun%C3%A7%C3%A3o_sigmoide
# [2] https://en.wikipedia.org/wiki/Logistic_regression 
def sigmoid(x: float) -> float:
    return 1.0/(1.0 + exp(-x))

# derivada da função sigmoid
def derivative_sigmoid(x: float) -> float:
    sig: float = sigmoid(x)
    return sig*(1-sig)     

