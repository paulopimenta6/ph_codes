from __future__ import annotations
from typing import List, Callable, Optional
from random import random
from neuron import Neuron
from util import dot_product

class Layer:
    def __init__(self, previous_layer: Optional[Layer], num_neurons: int,
    learning_rate: float, activation_function: Callable[[float], float],
    derivative_activation_function: Callable[[float], float]) -> None:
    