import numpy as np


def train_test_split(
    X: np.ndarray,
    y: np.ndarray,
    test_size: float = 0.2,
    random_state: int | None = None,
):
    X = np.asarray(X)
    y = np.asarray(y)
    if X.shape[0] == 0 or y.shape[0] == 0:
        raise ValueError("cannot split empty array")

    if random_state is not None:
        rng = np.random.RandomState(random_state)
    else:
        rng = np.random.RandomState()

    n = X.shape[0]
    indices = np.arange(n)
    rng.shuffle(indices)

    split = int(n * (1 - test_size))
    train_idx = indices[:split]
    test_idx = indices[split:]

    return X[train_idx], X[test_idx], y[train_idx], y[test_idx]


class StandardScaler:
    def __init__(self):
        self._mean = None
        self._std = None

    def fit(self, X: np.ndarray):
        X = np.asarray(X, dtype=np.float64)
        self._mean = X.mean(axis=0)
        self._std = X.std(axis=0) + 1e-9
        return self

    def transform(self, X: np.ndarray) -> np.ndarray:
        X = np.asarray(X, dtype=np.float64)
        return (X - self._mean) / self._std

    def fit_transform(self, X: np.ndarray) -> np.ndarray:
        return self.fit(X).transform(X)


class LabelEncoder:
    def __init__(self):
        self._classes = None
        self._mapping = {}

    def fit(self, y: np.ndarray):
        self._classes = np.unique(y)
        self._mapping = {c: i for i, c in enumerate(self._classes)}
        return self

    def transform(self, y: np.ndarray) -> np.ndarray:
        return np.array([self._mapping[val] for val in y])

    def fit_transform(self, y: np.ndarray) -> np.ndarray:
        return self.fit(y).transform(y)

    def inverse_transform(self, y: np.ndarray) -> np.ndarray:
        inverse = {i: c for c, i in self._mapping.items()}
        return np.array([inverse[val] for val in y])
