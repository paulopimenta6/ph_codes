"""Training script for credit card fraud detection.

Usage example:
python src/train.py --data data/creditcard.csv --model-output models/model.joblib --metrics-output models/metrics.json
"""
import argparse, json
from pathlib import Path
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import HistGradientBoostingClassifier
from sklearn.metrics import roc_auc_score
from src.features.features import basic_feature_generation
from utils import save_model, compute_metrics

def try_import_xgb():
    try:
        import xgboost as xgb  # type: ignore
        return xgb
    except Exception:
        return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--data', required=True)
    parser.add_argument('--model-output', required=True)
    parser.add_argument('--metrics-output', required=True)
    args = parser.parse_args()

    df = pd.read_csv(args.data)
    df = basic_feature_generation(df)

    target_col = 'Class' if 'Class' in df.columns else 'label'
    X = df.drop(columns=[target_col])
    y = df[target_col].values

    # keep only numeric columns
    X = X.select_dtypes(include=[np.number])

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, stratify=y, random_state=42)
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    xgb = try_import_xgb()
    if xgb is not None:
        # use xgboost classifier with scale_pos_weight to help imbalance
        scale_pos = max(1, (y_train==0).sum() / max(1, (y_train==1).sum()))
        model = xgb.XGBClassifier(use_label_encoder=False, eval_metric='logloss', n_estimators=200, max_depth=6, scale_pos_weight=scale_pos, n_jobs=4)
        model.fit(X_train_scaled, y_train)
        # wrap predict_proba -> positive class
        def predict_proba_fn(X):
            return model.predict_proba(X)[:,1]
        proba_test = predict_proba_fn(X_test_scaled)
    else:
        # fallback model
        model = HistGradientBoostingClassifier(max_iter=200)
        model.fit(X_train_scaled, y_train)
        proba_test = model.predict_proba(X_test_scaled)[:,1]

    # compute metrics and save model + scaler
    metrics = compute_metrics(y_test, proba_test, threshold=0.5)
    # save scaler and model together
    import joblib
    artifact = {'model': model, 'scaler': scaler, 'features': list(X.columns)}
    Path(args.model_output).parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(artifact, args.model_output)
    with open(args.metrics_output, 'w') as f:
        json.dump(metrics, f, indent=2)

    print('Training finished. Metrics:')
    print(json.dumps(metrics, indent=2))

if __name__ == '__main__':
    main()
