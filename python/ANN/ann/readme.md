# 🧠 Tutorial: Redes Neurais Artificiais do Zero
### Baseado na obra de David Kopec | Implementação em Python

Este guia serve como material de apoio para estudantes e desenvolvedores que desejam entender a implementação de uma **Rede Neural Artificial (ANN)** construída puramente em Python, focando nos fundamentos matemáticos e na arquitetura de código, sem o uso de frameworks externos.

---

## 1. O Conceito Fundamental
Uma Rede Neural Artificial é inspirada no funcionamento biológico do cérebro humano. O objetivo é criar um sistema capaz de **aprender** a mapear entradas (inputs) para saídas (outputs) através de exemplos.

### A Estrutura Básica do Projeto
O código está dividido em três classes principais que abstraem a complexidade:
1.  **Neuron (Neurônio):** A unidade básica de processamento.
2.  **Layer (Camada):** Um conjunto de neurônios trabalhando em paralelo.
3.  **Network (Rede):** O gerenciador que conecta as camadas e executa o aprendizado.

---

## 2. O Neurônio (`Neuron`)
Cada neurônio recebe dados, processa-os e decide o quanto "disparar" de sinal para o próximo.

![Diagrama do Neurônio](../img/neurons.jpeg)

### A Matemática Interna
O neurônio realiza duas operações principais:

1.  **Combinação Linear (Dot Product):** Multiplica as entradas pelos **pesos** ($w$) e soma com um viés (**bias**).
    $$z = (x_1 \cdot w_1) + (x_2 \cdot w_2) + ... + bias$$

2.  **Função de Ativação:** O resultado $z$ passa por uma função que "esmaga" o valor para um intervalo conhecido (geralmente entre 0 e 1). Neste projeto, usamos a **Sigmoide**:
    $$S(x) = \frac{1}{1 + e^{-x}}$$

> **Nota:** A derivada da Sigmoide ($S'(x) = S(x) * (1 - S(x))$) é crucial para o algoritmo de aprendizagem (backpropagation).

---

## 3. Arquitetura da Rede (`Layer` e `Network`)
As redes neurais modernas são organizadas em camadas sequenciais.

* **Input Layer:** Recebe os dados brutos.
* **Hidden Layers:** Onde a "mágica" acontece. Extraem características complexas dos dados.
* **Output Layer:** Entrega a previsão final (ex: Classificação da espécie da planta).

### Fluxo de Dados (Feedforward)
A informação viaja em sentido único:
`Input` $\rightarrow$ `Processamento na Camada Oculta` $\rightarrow$ `Ativação` $\rightarrow$ `Output`

No código, o método `outputs()` da classe `Network` é responsável por propagar esse sinal camada por camada até o final.

---

## 4. O Aprendizado (Backpropagation)
Como a rede aprende? Ajustando os **Pesos** e o **Bias** para minimizar o erro.

O algoritmo **Backpropagation** (Propagação Reversa) funciona em 4 passos cíclicos:
1.  **Feedforward:** A rede faz uma previsão com os pesos atuais.
2.  **Cálculo do Erro:** Compara a previsão com a resposta real (esperada).
3.  **Cálculo dos Deltas:** Calcula a responsabilidade de cada neurônio no erro final.
4.  **Atualização:** Ajusta os pesos levemente na direção oposta ao erro, multiplicado por uma **Taxa de Aprendizado** (Learning Rate).

---

## 5. Estrutura do Código
O projeto é modular para facilitar o estudo. Abaixo, um resumo das responsabilidades:

| Classe/Função | Responsabilidade |
| :--- | :--- |
| `util.py` | Funções auxiliares (produto escalar, sigmoide, derivada). |
| `Neuron` | Armazena `weights`, `learning_rate`, `output_cache` e `delta`. |
| `Layer` | Gerencia uma lista de neurônios. |
| `Network` | Orquestra o treino (`train`) e a validação (`validate`). |

### Exemplo de Uso

```python
from ann import Network

# 1. Definir a estrutura (ex: 2 entradas, 4 ocultos, 3 saídas)
structure = [2, 4, 3]
rede = Network(structure, learning_rate=0.3)

# 2. Treinar com dados (Inputs e Esperados)
# Exemplo clássico: Dataset Iris
rede.train(inputs, expecteds)

# 3. Validar
resultado = rede.validate(test_inputs, test_expecteds)
print(f"Acurácia da rede: {resultado}%")