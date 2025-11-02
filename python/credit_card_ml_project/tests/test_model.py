import pytest
import pandas as pd
from src.features import basic_feature_generation
from pathlib import Path
import joblib

def test_basic_feature_generation():
    df = pd.DataFrame({'Time':[0,3600,7200], 'Amount':[10.0, 0.0, 50.0], 'V1':[0.1, -0.2, 0.3]})
    out = basic_feature_generation(df)
    assert 'log_amount' in out.columns
    assert 'hour' in out.columns
    assert out['log_amount'].isnull().sum() == 0

def test_model_artifact_exists():
    p = Path('models/model.joblib')
    assert p.exists(), 'Model artifact models/model.joblib deve existir para os testes.'
    art = joblib.load(p)
    assert 'model' in art and 'scaler' in art and 'features' in art
