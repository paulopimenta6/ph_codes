import numpy as np
from scipy.stats import norm
from collections import defaultdict, Counter


class GaussianNB:
    def __init__(self):
        self._classes = None
        self._priors = {}
        self._params = {}

    def fit(self, X: np.ndarray, y: np.ndarray):
        X = np.asarray(X, dtype=np.float64)
        y = np.asarray(y)
        self._classes = np.unique(y)

        for c in self._classes:
            X_c = X[y == c]
            self._priors[c] = X_c.shape[0] / X.shape[0]
            self._params[c] = {
                "mean": X_c.mean(axis=0),
                "var": X_c.var(axis=0) + 1e-9,
            }

        return self

    def predict(self, X: np.ndarray) -> np.ndarray:
        probs = self.predict_proba(X)
        return self._classes[np.argmax(probs, axis=1)]

    def predict_proba(self, X: np.ndarray) -> np.ndarray:
        if self._classes is None:
            raise RuntimeError("call fit() before predict()")
        X = np.asarray(X, dtype=np.float64)
        probs = np.zeros((X.shape[0], len(self._classes)))

        for i, c in enumerate(self._classes):
            mean = self._params[c]["mean"]
            var = self._params[c]["var"]
            prior = np.log(self._priors[c])
            likelihood = norm.logpdf(X, loc=mean, scale=np.sqrt(var)).sum(axis=1)
            probs[:, i] = prior + likelihood

        probs -= probs.max(axis=1, keepdims=True)
        probs = np.exp(probs)
        probs /= probs.sum(axis=1, keepdims=True)
        return probs


class CategoricalNB:
    def __init__(self, alpha: float = 1.0):
        if alpha < 0:
            raise ValueError("alpha must be non-negative")
        self._alpha = alpha
        self._classes = None
        self._priors = {}
        self._feature_probs = {}

    def fit(self, X: np.ndarray, y: np.ndarray):
        X = np.asarray(X, dtype=np.int64)
        y = np.asarray(y)
        self._classes = np.unique(y)
        n_features = X.shape[1]

        for c in self._classes:
            X_c = X[y == c]
            self._priors[c] = X_c.shape[0] / X.shape[0]
            self._feature_probs[c] = []

            for f in range(n_features):
                counts = Counter(X_c[:, f])
                probs = np.zeros(self._n_categories(X, f))
                for val, count in counts.items():
                    probs[val] = count
                probs = (probs + self._alpha) / (
                    probs.sum() + self._alpha * len(probs)
                )
                self._feature_probs[c].append(probs)

        return self

    def predict(self, X: np.ndarray) -> np.ndarray:
        probs = self.predict_proba(X)
        return self._classes[np.argmax(probs, axis=1)]

    def predict_proba(self, X: np.ndarray) -> np.ndarray:
        if self._classes is None:
            raise RuntimeError("call fit() before predict()")
        X = np.asarray(X, dtype=np.int64)
        probs = np.zeros((X.shape[0], len(self._classes)))

        for i, c in enumerate(self._classes):
            log_prior = np.log(self._priors[c])
            log_likelihood = np.zeros(X.shape[0])

            for f in range(X.shape[1]):
                feat_probs = self._feature_probs[c][f]
                n_cat = len(feat_probs)
                vals = X[:, f]
                safe_vals = np.where(vals < n_cat, vals, n_cat - 1)
                log_likelihood += np.log(feat_probs[safe_vals])

            probs[:, i] = log_prior + log_likelihood

        probs -= probs.max(axis=1, keepdims=True)
        probs = np.exp(probs)
        probs /= probs.sum(axis=1, keepdims=True)
        return probs

    def _n_categories(self, X: np.ndarray, f: int) -> int:
        return int(X[:, f].max()) + 1
