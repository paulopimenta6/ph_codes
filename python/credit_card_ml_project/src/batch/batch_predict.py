"""Script para predições em lote com chunking para grandes volumes de dados."""
import argparse, csv
import pandas as pd
import numpy as np
from pathlib import Path
import joblib
from src.features.features import basic_feature_generation
from src.utils.utils import load_model

def load_artifact(path):
    return joblib.load(path)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True, help='CSV input path')
    parser.add_argument('--model', required=True, help='Model artifact path (joblib)')
    parser.add_argument('--output', required=True, help='Output CSV path')
    parser.add_argument('--chunksize', type=int, default=100000)
    args = parser.parse_args()

    artifact = load_artifact(args.model)
    scaler = artifact['scaler']
    features = artifact['features']

    reader = pd.read_csv(args.input, chunksize=args.chunksize)
    first = True
    for chunk in reader:
        chunk = basic_feature_generation(chunk)
        X = chunk.reindex(columns=features).fillna(0.0).select_dtypes(include=[float, int])
        Xs = scaler.transform(X)
        model = artifact['model']
        if hasattr(model, 'predict_proba'):
            proba = model.predict_proba(Xs)[:,1]
        else:
            proba = model.predict(Xs)
        out = chunk.copy()
        out['fraud_probability'] = proba
        mode = 'w' if first else 'a'
        header = first
        out.to_csv(args.output, mode=mode, index=False, header=header)
        first = False

if __name__ == '__main__':
    main()
