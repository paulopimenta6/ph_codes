# Naive Bayes - Implementação Didática

Implementação do classificador Naive Bayes (Gaussiano e Categórico) em Python puro com NumPy e SciPy, acompanhada de utilitários de pré-processamento, métricas de avaliação e testes unitários.

## Estrutura do Projeto

```
naive_bayes/
├── src/
│   ├── naive_bayes.py      # Classificadores GaussianNB e CategoricalNB
│   ├── preprocessing.py    # train_test_split, StandardScaler, LabelEncoder
│   ├── evaluation.py       # Acurácia, Precisão, Recall, F1, Matriz de Confusão
│   ├── utils.py            # Carregamento de datasets
│   └── data/iris.csv       # Dataset Iris embutido
├── tests/
│   ├── test_naive_bayes.py
│   ├── test_preprocessing.py
│   └── test_evaluation.py
├── examples/
│   └── example.py          # Exemplo completo de uso
├── docs/
│   └── tutorial.md         # Tutorial detalhado
├── requirements.txt
└── setup.py
```

## Instalação

```bash
pip install -r requirements.txt
```

## Exemplo Rápido

```python
import numpy as np
from src.naive_bayes import GaussianNB
from src.preprocessing import train_test_split, StandardScaler, LabelEncoder
from src.evaluation import accuracy_score, classification_report
from src.utils import load_iris

X, y = load_iris()

encoder = LabelEncoder()
y_encoded = encoder.fit_transform(y)

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y_encoded, test_size=0.3, random_state=42
)

model = GaussianNB()
model.fit(X_train, y_train)

y_pred = model.predict(X_test)
print(f"Acurácia: {accuracy_score(y_test, y_pred):.4f}")
print(classification_report(y_test, y_pred))
```

```
Acurácia: 0.9556
Classification Report
============================================================
              precision    recall  f1-score     support
           0     1.000    1.000     1.000         19
           1     1.000    0.846     0.917         13
           2     0.857    1.000     0.923         12
------------------------------------------------------------
     accuracy                               0.956         44
============================================================
```

## Componentes

### Classificadores

| Classe | Descrição |
|--------|-----------|
| `GaussianNB` | Para features contínuas. Assume distribuição normal por classe. |
| `CategoricalNB` | Para features categóricas. Aplica suavização Laplace (alpha). |

### Pré-processamento

| Classe/Função | Descrição |
|---------------|-----------|
| `train_test_split(X, y, test_size, random_state)` | Divide dados em treino e teste. |
| `StandardScaler` | Padroniza features (média 0, desvio 1). |
| `LabelEncoder` | Converte rótulos categóricos em números. |

### Métricas de Avaliação

| Função | Descrição |
|--------|-----------|
| `accuracy_score(y_true, y_pred)` | Proporção de acertos. |
| `precision_score(y_true, y_pred, average)` | Precisão (micro/macro/weighted/binary). |
| `recall_score(y_true, y_pred, average)` | Revocação (micro/macro/weighted/binary). |
| `f1_score(y_true, y_pred, average)` | F1-score (média harmônica). |
| `confusion_matrix(y_true, y_pred)` | Matriz de confusão NxN. |
| `classification_report(y_true, y_pred)` | Relatório completo em texto. |

## Testes

```bash
pytest tests/ -v
```

Com cobertura:

```bash
pytest tests/ --cov=src -v
```
