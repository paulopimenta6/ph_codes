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

acc = accuracy_score(y_test, y_pred)
print(f"Acurácia: {acc:.4f}")
print(classification_report(y_test, y_pred))

probs = model.predict_proba(X_test[:5])
print("\nProbabilidades (primeiras 5 amostras):")
print(probs)
