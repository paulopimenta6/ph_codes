from fastapi import FastAPI
from pydantic import BaseModel
import joblib
from typing import List

app = FastAPI(title='Credit Card Fraud Detection API')

class SingleInput(BaseModel):
    # Accept dynamic features: allow dict-like with numerical values via 'features'
    features: dict

class BatchInput(BaseModel):
    rows: List[dict]

# load model artifact
_artifact = None
def load_artifact(path='models/model.joblib'):
    global _artifact
    if _artifact is None:
        _artifact = joblib.load(path)
    return _artifact

@app.post('/predict_single')
def predict_single(payload: SingleInput):
    art = load_artifact()
    scaler = art['scaler']
    features = art['features']
    row = [payload.features.get(f, 0.0) for f in features]
    X = scaler.transform([row])
    proba = art['model'].predict_proba(X)[:,1][0] if hasattr(art['model'], 'predict_proba') else art['model'].predict(X)[0]
    return {'probability_fraud': float(proba), 'threshold_0.5_pred': int(proba>=0.5)}

@app.post('/predict_batch')
def predict_batch(payload: BatchInput):
    art = load_artifact()
    scaler = art['scaler']
    features = art['features']
    rows = []
    for r in payload.rows:
        rows.append([r.get(f, 0.0) for f in features])
    X = scaler.transform(rows)
    proba = art['model'].predict_proba(X)[:,1] if hasattr(art['model'], 'predict_proba') else art['model'].predict(X)
    return {'probabilities': proba.tolist()}
