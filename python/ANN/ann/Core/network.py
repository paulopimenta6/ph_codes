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

    # Calcula as mudancas em cada neuronio com base nos erros da saida
    # # em comparacao com a saida esperada.
    # A funcao backpropagate percorre as camadas da rede neural em ordem reversa,
    # começando pela camada de saida e indo em direcao a camada de entrada.
    def backpropagate(self, expected: List[float]) -> None:
        # Calcula delta para os neuronios da camada de saida
        last_layer: int = len(self.layers)-1
        self.layers[last_layer].calculate_deltas_for_output_layer(expected)
        # calcula delta para as camadas ocultas em ordem inversa 
        for l in range(last_layer-1, 0, -1):
            self.layers[l].calculate_deltas_for_hidden_layer(self.layers[l+1])

    # backpropagate() nao modifica realmente os pesos dos neuronios.
    # Esta funcao utiliza os deltas calculados em backpropagate() para
    # fazer as modificacoes nos pesos
    def update_weights(self) -> None:
        for layer in self.layers[1:]: # Ignora a camada de entrada
            for neuron in layer.neurons:
                for w in range(len(neuron.weights)):
                    neuron.weights[w] = neuron.weights[w] + (neuron.learning_rate
                    *(layer.previous_layer.output_cache[w])*neuron.delta)

    # Funcao de treinamento da rede neural.
    # train() usa os resultados de outputs, obtidos a partir de varias entradas e 
    # comparados com expecteds, para fornecer a backpropagate() e a update_weights()
    def train(self, inputs: List[List[float]], expecteds: List[List[float]]) -> None:
        for location, xs in enumerate(inputs):
            ys: List[float] = expecteds[location]
            outs: List[float] = self.outputs(xs)
            self.backpropagate(ys)
            self.update_weights()

    # Para resultados genericos que esijam classificacao,
    # esta funcao ira devolver o numero de tentativas corretas
    # da rede neural em relacao ao total de tentativas
    # em porcentagem
    def validate(self, inputs: List[List[float]], expecteds: List[T],
    interpret_output: Callable[[List[float]], T]) -> Tuple[int, int, float]:
        correct: int = 0
        for input, expected in zip(inputs, expecteds):
            result: T = interpret_output(self.outputs(input))
            if result == expected:
                correct += 1
        percentage: float = correct/len(inputs)
        return correct, len(inputs), percentage        
