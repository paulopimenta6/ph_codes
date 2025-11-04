# Credit Card Fraud Detection - ML Project

Projeto de Machine Learning criado como desafio. Contém:

- Treinamento e avaliação de modelo de detecção de fraude (XGBoost quando disponível).
- API (FastAPI) para predições instantâneas.
- Script para predições em lote usando chunking para grandes volumes.
- Geração de features e utilitários.
- Testes básicos com pytest.
- Arquitetura pensada para MLOps: artefatos versionados, requirements, Dockerfile.

Como usar (resumo):
1. Criar ambiente e instalar dependências: `pip install -r requirements.txt`
2. Treinar: `python src/model_pipeline/train.py --data data/creditcard.csv --model-output models/model.joblib --metrics-output models/metrics.json`
3. Rodar API: `uvicorn src.predict_api:app --host 0.0.0.0 --port 8080`
4. Predição em lote: `python src/batch/batch_predict.py --input large_input.csv --model models/model.joblib --output preds.csv`

Arquivos principais:
- `src/model_pipeline/train.py` : treinamento e avaliação
- `src/feattures/features.py` : funções de engenharia de features
- `src/predict_api.py` : FastAPI para predições instantâneas
- `src/btach/batch_predict.py` : processamento por chunks para predições em lote
- `src/utils/utils.py` : utilitários (salvar/carregar modelos, métricas)
- `tests/test_model.py` : testes pytest básicos

## Cookbook
1 - Como rodar localmente:
```{bash}
conda create -n cc-fraud python=3.10 -y
conda activate cc-fraud
pip install -r requirements.txt
``` 

2 - Treinamento do modelo:
Neste exemplo usou-se o método de XGBoost que pode ser conhecido [aqui](https://www.datageeks.com.br/xgboost/). O comando para treino, por sua vez, é: 

```{bash}
python src/train.py --data data/creditcard.csv --model-output models/model.joblib --metrics-output models/metrics.json
```

Após executar o comando azim algumas saídas serão criadas, tais como:
- models/model.joblib: Artefato contendo informaçẽos do treino: { 'model': model, 'scaler': scaler, 'features': [...], 'trained_with': ... }
- models/metrics.josn: Métricas de avaliação (roc_auc, precision, reclamm, f1, matriz de confusão)

3 - Execução de testes
```{bash}
pytest -q
```

4 - API (predição instantânea):
```{bash}
uvicorn src.predict_api:app --host 0.0.0.0 --port 8080
```

Lembrando que a porta 8080 pode estar em uso, por esta razão aconselha-se verificar se a porta está livre ou optar por outra, tal como 8081, 8082,...

ENDPOINTS (Aconselha-se usar o POSTMAN):

[Donwload do POSTMAN](https://www.postman.com/)

Fazendo um POST em http://localhist:8080/predict_single com o json:

```{json}
{
           "features": {
             "Time": 12345,
             "V1": -1.3598,
             "V2": 1.1918,
             "V3": -0.1234,
             "V4": 2.345,
             "V5": -0.987,
             "Amount": 150.0
           }
         }
```

a resposta será algo como:

```{json}
{"probability_fraud":1.8722910226642853e-06,"threshold_0.5_pred":0}
```