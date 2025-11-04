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

4 - API (predição instantânea)
Primeiramente é necessário subir o servidor com o comando:
```{bash}
uvicorn src.api.predict_api:app --host 0.0.0.0 --port 8080
```

Lembrando que a porta 8080 pode estar em uso, por esta razão aconselha-se verificar se a porta está livre ou optar por outra, tal como 8081, 8082,...

ENDPOINTS (Aconselha-se usar o POSTMAN):

[Donwload do POSTMAN](https://www.postman.com/)

Fazendo um POST em http://localhist:8080/predict_single com o json:

```{json}
{
           "features": {
        "Time": -1.3598071336738,
        "V1": -0.0727811733098497,
        "V2": 2.53634673796914,
        "V3": 1.37815522427443,
        "V4": -0.338320769942518,
        "V5": 0.462387777762292,
        "V6": 0.239598554061257,
        "V7": 0.0986979012610507,
        "V8": 0.363786969611213,
        "V9": 0.0907941719789316,
        "V10":  -0.551599533260813,
        "V11": -0.617800855762348,
        "V12": -0.991389847235408,
        "V13": -0.311169353699879,
        "V14": 1.46817697209427,
        "V15": -0.470400525259478,
        "V16": 0.207971241929242,
        "V17": 0.0257905801985591,
        "V18": 0.403992960255733,
        "V19": 0.251412098239705,
        "V20": -0.018306777944153,
        "V21": 0.277837575558899,
        "V22": -0.110473910188767,
        "V23": 0.0669280749146731,
        "V24": 0.128539358273528,
        "V25": -0.189114843888824,
        "V26": 0.133558376740387,
        "V27": -0.0210530534538215,
        "Amount": 149.62
           }
}
```

a resposta será algo como:

```{json}
{"probability_fraud":1.3421650635336846e-07,"threshold_0.5_pred":0}
```

5 - Predição em lote
```{bash}
python src/batch/batch_predict.py --input large_input.csv --model models/model.joblib --output preds.csv --chunksize 100000
```

ou via POSTMAN no endereço http://localhost:8080/prediction_batch:
```{json}
{
           "rows": [
             { "Time": 12345, "V1": -1.3598, "V2": 1.1918, "V3": -0.1234, "V4": 2.345, "V5": -0.987, "Amount": 150.0 },
             { "Time": 23456, "V1": 0.234, "V2": -0.876, "V3": 1.123, "V4": -0.543, "V5": 0.789, "Amount": 85.0 }
           ]
}
```

6 - Docker
Para uso no docker e inclusão em pipeline:

- Build:
```{bash}
docker build -t cc-fraud:latest .
```

- Run:
```{Bash}
docker run -p 8000:8080 cc-fraud:latest
```

7 - Testes via python
É possível fazer um script via python para realizar testes. Segue um modelo:

```{python}
import requests

url = "http://127.0.0.1:8000/predict_single"

payload = {
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

response = requests.post(url, json=payload)
print(response.json())
```