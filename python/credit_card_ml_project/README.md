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
2. Treinar: `python src/train.py --data data/creditcard.csv --model-output models/model.joblib --metrics-output models/metrics.json`
3. Rodar API: `uvicorn src.predict_api:app --host 0.0.0.0 --port 8000`
4. Predição em lote: `python src/batch_predict.py --input large_input.csv --model models/model.joblib --output preds.csv`

Arquivos principais:
- `src/model_pipeline/train.py` : treinamento e avaliação
- `src/feattures/features.py` : funções de engenharia de features
- `src/predict_api.py` : FastAPI para predições instantâneas
- `src/btach/batch_predict.py` : processamento por chunks para predições em lote
- `src/utils/utils.py` : utilitários (salvar/carregar modelos, métricas)
- `tests/test_model.py` : testes pytest básicos

Como rodar localmente (passo a passo):
```{bash}
conda create -n cc-fraud python=3.10 -y
conda activate cc-fraud
pip install -r requirements.txt
``` 