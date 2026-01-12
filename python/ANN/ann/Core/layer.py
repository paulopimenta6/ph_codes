from __future__ import annotations
from typing import List, Callable, Optional
from random import random
from neuron import Neuron
from util import dot_product

class Layer:
    def __init__(self, previous_layer: Optional[Layer], num_neurons: int,
    learning_rate: float, activation_function: Callable[[float], float],
    derivative_activation_function: Callable[[float], float]) -> None:
        self.previous_layer: Optional[Layer] = previous_layer
        self.neurons: List[Neuron] = []
        # O código abaixo cria `num_neurons` neurônios para esta camada.
        # - Se não existe `previous_layer`, esta é a camada de entrada: os neurônios
        #   não precisam de pesos porque apenas repassam os inputs.
        # - Caso contrário (camada oculta ou de saída), inicializamos um vetor de
        #   pesos aleatórios com comprimento igual ao número de neurônios na camada anterior.
        # Optamos por um loop explícito para ficar mais legível para fins didáticos.
        for i in range(num_neurons):
            # Camada de entrada: não há pesos (os valores virão diretamente dos inputs)
            if previous_layer is None:
                random_weights: List[float] = []
            else:
                # Um peso por neurônio da camada anterior, inicializado aleatoriamente
                random_weights = [random() for _ in range(len(previous_layer.neurons))]
            # Cria o neurônio com pesos iniciais, taxa de aprendizado e funções de ativação
            neuron: Neuron = Neuron(
                random_weights,
                learning_rate,
                activation_function,
                derivative_activation_function,
            )
            self.neurons.append(neuron)
        # `output_cache` guarda a última saída calculada pela camada para uso posterior
        self.output_cache: List[float] = [0.0 for _ in range(num_neurons)]

    def outputs(self, inputs: List[float]) -> List[float]:
        if self.previous_layer is None:
            # Camada de entrada: os valores de saída são os próprios inputs (sem processamento)
            self.output_cache = inputs
        else:
            # Para cada neurônio da camada, calcula sua saída a partir dos inputs
            # (normalmente os outputs da camada anterior).
            self.output_cache = [n.output(inputs) for n in self.neurons]
        return self.output_cache

    # Calculo de deltas: deve ser chamado somente na camada de saida   
    def calculate_deltas_for_output_layer(self, expected: List[float]) -> None:
        # Para cada neurônio, calcula o delta com base na diferença entre a saída esperada e a saída atual 
        for n in range(len(self.neurons)):
            self.neurons[n].delta = self.neurons[n].derivative_activation_function(
                self.neurons[n].output_cache)*(expected[n]-self.output_cache[n])

    #Nao deve ser chamado na camada de saida
    def calculate_deltas_for_hidden_layer(self, next_layer: Layer) -> None:
        # Para cada neurônio nesta camada, calcula o delta com base nos deltas e pesos da próxima camada
        for index, neuron in enumerate(self.neurons):
            next_weights:List[float] = [n.weights[index] for n in next_layer.neurons]
            next_deltas: List[float] = [n.delta for n in next_layer.neurons]
            sum_weights_and_deltas: float = dot_product(next_weights, next_deltas)
            # Atualiza o delta do neurônio atual
            neuron.delta = neuron.derivative_activation_function(neuron.output_cache)*sum_weights_and_deltas