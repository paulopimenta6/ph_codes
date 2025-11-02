"""Feature engineering utilities"""
import pandas as pd
import numpy as np

def basic_feature_generation(df: pd.DataFrame) -> pd.DataFrame:
    """Generate features commonly useful for credit-card-fraud dataset.
    The original dataset already contains PCA features V1..V28; here we add:
    - log_amount: log(Amount + 1)
    - hour: hour of transaction from Time (seconds since first transaction)
    - amount_to_mean: ratio of Amount to rolling mean (simple global mean here)
    - interaction features between Amount and top PCA features
    """
    df = df.copy()
    if 'Amount' in df.columns:
        df['log_amount'] = np.log1p(df['Amount'])
        mean_amt = df['Amount'].mean() if df['Amount'].notnull().any() else 0.0
        df['amount_to_mean'] = df['Amount'] / (mean_amt + 1e-9)
    if 'Time' in df.columns:
        # convert seconds to hour of day (approx)
        df['hour'] = ((df['Time'] // 3600) % 24).astype(int)
    # interaction examples
    pca_cols = [c for c in df.columns if c.startswith('V')][:4]
    for c in pca_cols:
        df[f'inter_{c}_logamt'] = df[c] * df.get('log_amount', 0.0)
    # Fill NA and ensure numeric dtype for ML
    df = df.fillna(0.0)
    return df
