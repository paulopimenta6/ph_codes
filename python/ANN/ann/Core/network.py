from __future__ import annotations
from typing import List, Callable, TypeVar, Tuple
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
            raise ValueError("Error: A rede neural deve ter pelo menos 3 camadas (entrada, oculta e saida).")
        self.layers: List[Layer] = []
        # Camada de entrada 
        input_layer: Layer = Layer(None, layer_structure[0], learning_rate,
            activation_function, derivative_activation_function)
        self.layers.append(input_layer)
        # Camadas ocultas e de saida
        for previous, num_neurons in enumerate(layer_structure[1::]):
            next_layer = Layer(self.layers[previous], num_neurons,
                learning_rate, activation_function, derivative_activation_function)
            self.layers.append(next_layer)

    # As saidas da rede neural sao o resultado dos sinais processadors por todas as suas camadas.
    # Nesta funcao os dados sao fornecidos para a primeira camada, em seguida, a saida da primeira
    # e fornecida como entrada para a segunda, a segunda para a terceira e assim sucessivamente a depender
    # do numero de camadas da rede neural.
    def outputs(self, input: List[float]) -> List[float]:
        return reduce(lambda inputs, layer: layer.outputs(inputs), self.layers, input)  