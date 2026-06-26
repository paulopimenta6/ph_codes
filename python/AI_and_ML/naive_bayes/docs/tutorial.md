# Tutorial Detalhado: Classificação com Naive Bayes

Este tutorial guia você desde a teoria do Naive Bayes até a classificação de um dataset real usando esta implementação.

## Índice

1. [Fundamentação Teórica](#1-fundamentação-teórica)
2. [Instalação](#2-instalação)
3. [Classificação com GaussianNB (Features Contínuas)](#3-classificação-com-gaussiannb-features-contínuas)
4. [Classificação com CategoricalNB (Features Categóricas)](#4-classificação-com-categoricalnb-features-categóricas)
5. [Pré-processamento de Dados](#5-pré-processamento-de-dados)
6. [Avaliação do Modelo](#6-avaliação-do-modelo)
7. [Pipeline Completo](#7-pipeline-completo)
8. [Trabalhando com CSV Externo](#8-trabalhando-com-csv-externo)
9. [Referências](#9-referências)

---

## 1. Fundamentação Teórica

O Naive Bayes é um classificador probabilístico baseado no **Teorema de Bayes**:

```
P(y | X) = P(y) * P(X | y) / P(X)
```

Onde:
- `P(y | X)`: probabilidade da classe y dadas as features X (**posteriori**)
- `P(y)`: probabilidade da classe y (**prior**)
- `P(X | y)`: verossimilhança de X dado y (**likelihood**)
- `P(X)`: evidência (normalização)

A suposição **"naive"** é que as features são condicionalmente independentes dada a classe:

```
P(X | y) = P(x₁ | y) * P(x₂ | y) * ... * P(xₙ | y)
```

### Gaussian Naive Bayes

Assume que cada feature contínua segue uma distribuição normal:

```
P(xᵢ | y) = (1 / √(2πσ²)) * exp(-(xᵢ - μ)² / (2σ²))
```

- `μ`: média da feature para a classe
- `σ²`: variância da feature para a classe

### Categorical Naive Bayes

Para features discretas, conta as ocorrências e aplica **suavização de Laplace** para evitar probabilidade zero:

```
P(xᵢ = v | y) = (Nᵢᵥ + α) / (Nᵧ + α * n_categorias)
```

- `Nᵢᵥ`: número de amostras da classe y com valor v na feature i
- `Nᵧ`: total de amostras da classe y
- `α`: parâmetro de suavização (1.0 por padrão)

---

## 2. Instalação

```bash
# Clone ou entre no diretório do projeto
cd naive_bayes

# Instale as dependências
pip install -r requirements.txt
```

Dependências:
- `numpy >= 1.24.0`: operações matriciais
- `scipy >= 1.10.0`: funções de distribuição de probabilidade
- `pytest >= 7.4.0`: execução dos testes
- `pytest-cov >= 4.1.0`: relatório de cobertura

---

## 3. Classificação com GaussianNB (Features Contínuas)

### 3.1 Dataset Sintético Binário

```python
import numpy as np
from src.naive_bayes import GaussianNB

X = np.array([
    [1.0, 2.0],
    [1.5, 2.5],
    [2.0, 3.0],
    [5.0, 6.0],
    [5.5, 6.5],
    [6.0, 7.0],
])
y = np.array([0, 0, 0, 1, 1, 1])

model = GaussianNB()
model.fit(X, y)

y_pred = model.predict(X)
print("Predições:", y_pred)
```

### 3.2 Probabilidades das Classes

```python
probs = model.predict_proba(np.array([[3.0, 4.0]]))
print("Probabilidades:", probs)
# Exemplo: [[0.98, 0.02]] -> 98% classe 0, 2% classe 1
```

### 3.3 Dataset Iris (3 classes, 4 features)

```python
from src.naive_bayes import GaussianNB
from src.preprocessing import StandardScaler
from src.utils import load_iris

X, y = load_iris()
print(f"Dimensões: {X.shape}")  # (150, 4)
print(f"Classes: {np.unique(y)}")  # ['setosa' 'versicolor' 'virginica']

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

model = GaussianNB()
model.fit(X_scaled, y)

# Predição de uma nova flor
nova_flor = np.array([[5.1, 3.5, 1.4, 0.2]])
nova_flor_scaled = scaler.transform(nova_flor)
pred = model.predict(nova_flor_scaled)
print(f"Classe predita: {pred[0]}")  # setosa

probs = model.predict_proba(nova_flor_scaled)
print(f"Probabilidades: {probs[0]}")
```

---

## 4. Classificação com CategoricalNB (Features Categóricas)

### 4.1 Dataset Sintético Discreto

```python
import numpy as np
from src.naive_bayes import CategoricalNB

X = np.array([
    [0, 1],
    [0, 1],
    [1, 0],
    [1, 0],
])
y = np.array([0, 0, 1, 1])

model = CategoricalNB(alpha=1.0)
model.fit(X, y)

y_pred = model.predict(X)
print("Predições:", y_pred)
```

### 4.2 Lidando com Categorias não Vistas

```python
X_train = np.array([[0], [0], [1]])
y_train = np.array([0, 0, 1])

model = CategoricalNB(alpha=1.0)
model.fit(X_train, y_train)

# Categoria não vista no treino
X_test = np.array([[2]])
probs = model.predict_proba(X_test)
print("Probabilidades (categoria 2 não vista):", probs)
# Suavização de Laplace evita probabilidade zero
```

### 4.3 Ajustando a Suavização

```python
# Sem suavização
model_no_smooth = CategoricalNB(alpha=0.0)
# Suavização forte
model_strong_smooth = CategoricalNB(alpha=10.0)
```

---

## 5. Pré-processamento de Dados

### 5.1 Divisão Treino-Teste

```python
from src.preprocessing import train_test_split

X = np.arange(100).reshape(50, 2)
y = np.arange(50)

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

print(f"Treino: {X_train.shape[0]} amostras")
print(f"Teste: {X_test.shape[0]} amostras")
```

### 5.2 Padronização (StandardScaler)

Remove a média e escala para variância unitária:

```python
from src.preprocessing import StandardScaler

X = np.array([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

print("Média após escala:", X_scaled.mean(axis=0))  # ~[0, 0]
print("Desvio após escala:", X_scaled.std(axis=0))  # ~[1, 1]
```

### 5.3 Codificação de Rótulos (LabelEncoder)

```python
from src.preprocessing import LabelEncoder

y = np.array(["setosa", "versicolor", "virginica", "setosa"])
encoder = LabelEncoder()
y_encoded = encoder.fit_transform(y)
print("Codificado:", y_encoded)  # [0, 1, 2, 0]

# Reverter
y_decoded = encoder.inverse_transform(y_encoded)
print("Original:", y_decoded)
```

---

## 6. Avaliação do Modelo

### 6.1 Acurácia

```python
from src.evaluation import accuracy_score

y_true = np.array([0, 1, 0, 1])
y_pred = np.array([0, 1, 0, 1])
print(accuracy_score(y_true, y_pred))  # 1.0 (100%)
```

### 6.2 Matriz de Confusão

```python
from src.evaluation import confusion_matrix

y_true = np.array([0, 0, 1, 1])
y_pred = np.array([0, 1, 0, 1])
cm = confusion_matrix(y_true, y_pred)
print(cm)
# [[1, 1],
#  [1, 1]]
```

### 6.3 Precisão, Recall e F1

```python
from src.evaluation import precision_score, recall_score, f1_score

y_true = np.array([0, 0, 1, 1, 1])
y_pred = np.array([0, 1, 1, 1, 0])

# Para classificação binária
print("Precisão:", precision_score(y_true, y_pred, average="binary", pos_label=1))
print("Recall:", recall_score(y_true, y_pred, average="binary", pos_label=1))
print("F1:", f1_score(y_true, y_pred, average="binary", pos_label=1))

# Média macro (calcula para cada classe e tira a média)
print("Precisão (macro):", precision_score(y_true, y_pred, average="macro"))
print("F1 (weighted):", f1_score(y_true, y_pred, average="weighted"))
```

### 6.4 Relatório Completo

```python
from src.evaluation import classification_report

report = classification_report(y_true, y_pred)
print(report)
```

---

## 7. Pipeline Completo

Pipeline completo do início ao fim com o dataset Iris:

```python
import numpy as np
from src.naive_bayes import GaussianNB
from src.preprocessing import train_test_split, StandardScaler, LabelEncoder
from src.evaluation import accuracy_score, classification_report
from src.utils import load_iris

def pipeline():
    # 1. Carregar dados
    X, y = load_iris()

    # 2. Codificar rótulos
    encoder = LabelEncoder()
    y_encoded = encoder.fit_transform(y)

    # 3. Padronizar features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    # 4. Dividir treino/teste
    X_train, X_test, y_train, y_test = train_test_split(
        X_scaled, y_encoded, test_size=0.3, random_state=42
    )

    print(f"Treino: {X_train.shape[0]} amostras")
    print(f"Teste: {X_test.shape[0]} amostras")

    # 5. Treinar modelo
    model = GaussianNB()
    model.fit(X_train, y_train)

    # 6. Predizer
    y_pred = model.predict(X_test)

    # 7. Avaliar
    acc = accuracy_score(y_test, y_pred)
    print(f"\nAcurácia: {acc:.4f}")
    print(classification_report(y_test, y_pred))

    return model, scaler, encoder

model, scaler, encoder = pipeline()
```

---

## 8. Trabalhando com CSV Externo

### 8.1 Usando load_csv

Para carregar seu próprio dataset CSV (última coluna = rótulo):

```python
from src.utils import load_csv
from src.naive_bayes import GaussianNB
from src.preprocessing import StandardScaler, train_test_split
from src.evaluation import accuracy_score

data, headers = load_csv("seu_dataset.csv")
print("Cabeçalhos:", headers)
print("Dimensões:", data.shape)

X = data[:, :-1]
y = data[:, -1].astype(int)

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.2, random_state=42
)

model = GaussianNB()
model.fit(X_train, y_train)

y_pred = model.predict(X_test)
print(f"Acurácia: {accuracy_score(y_test, y_pred):.4f}")
```

### 8.2 Formato Esperado do CSV

```
feature1,feature2,feature3,label
1.2,3.4,5.6,0
2.3,4.5,6.7,1
...
```

- Primeira linha: cabeçalho (opcional, mas recomendado)
- Última coluna: rótulo da classe (valor numérico)
- Demais colunas: features numéricas

---

## 9. Referências

1. **Pattern Recognition and Machine Learning** - Christopher Bishop
2. **The Elements of Statistical Learning** - Hastie, Tibshirani, Friedman
3. **Scikit-learn: Naive Bayes** - Documentação oficial
4. **Teorema de Bayes** - Wikipedia
