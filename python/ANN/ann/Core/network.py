from __future__ import annotations
from typing import List, Callable, typeVar, Tuple
from functools import reduce
from layer import Layer
from util import sigmoid, derivative_sigmoid

# Tipo generico para entradas e saidas da rede neural
T = TypeVar('T')

class Network:
    def __init__(self, layer_structure: List[int], learning_rate: float,
    activation_function: Callable[[float], float] = sigmoid,
    derivative_activation_function: Callable[[float], float] = derivative_sigmoid) -> None:
        if len(layer_structure) < 3: