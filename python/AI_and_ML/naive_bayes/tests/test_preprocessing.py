import numpy as np
import pytest
from src.preprocessing import train_test_split, StandardScaler, LabelEncoder


class TestTrainTestSplit:
    def test_split_default(self):
        X = np.arange(100).reshape(50, 2)
        y = np.arange(50)
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
        assert X_train.shape[0] == 40
        assert X_test.shape[0] == 10
        assert y_train.shape[0] == 40
        assert y_test.shape[0] == 10

    def test_split_ratio(self):
        X = np.arange(100).reshape(50, 2)
        y = np.arange(50)
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)
        assert X_train.shape[0] == 35
        assert X_test.shape[0] == 15

    def test_reproducible_seed(self):
        X = np.arange(100).reshape(50, 2)
        y = np.arange(50)
        r1 = train_test_split(X, y, test_size=0.2, random_state=42)
        r2 = train_test_split(X, y, test_size=0.2, random_state=42)
        for a, b in zip(r1, r2):
            np.testing.assert_array_equal(a, b)

    def test_raises_on_empty(self):
        X = np.array([]).reshape(0, 2)
        y = np.array([])
        with pytest.raises(ValueError):
            train_test_split(X, y, test_size=0.2)


class TestStandardScaler:
    def test_fit_transform(self):
        X = np.array([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(X)
        assert np.allclose(X_scaled.mean(axis=0), [0.0, 0.0], atol=1e-9)
        assert np.allclose(X_scaled.std(axis=0), [1.0, 1.0], atol=1e-6)

    def test_transform_single_row(self):
        X = np.array([[1.0, 2.0], [3.0, 4.0]])
        scaler = StandardScaler()
        scaler.fit(X)
        X_row = np.array([[2.0, 3.0]])
        X_scaled = scaler.transform(X_row)
        assert X_scaled.shape == (1, 2)

    def test_fit_twice_overwrites(self):
        X1 = np.array([[1.0, 2.0], [3.0, 4.0]])
        X2 = np.array([[10.0, 20.0], [30.0, 40.0]])
        scaler = StandardScaler()
        scaler.fit(X1)
        scaler.fit(X2)
        X_scaled = scaler.transform(X2)
        assert np.allclose(X_scaled.mean(axis=0), [0.0, 0.0], atol=1e-9)


class TestLabelEncoder:
    def test_fit_transform(self):
        y = np.array(["a", "b", "c", "a"])
        encoder = LabelEncoder()
        encoded = encoder.fit_transform(y)
        np.testing.assert_array_equal(encoded, [0, 1, 2, 0])

    def test_inverse_transform(self):
        y = np.array(["a", "b", "c"])
        encoder = LabelEncoder()
        encoded = encoder.fit_transform(y)
        decoded = encoder.inverse_transform(encoded)
        np.testing.assert_array_equal(decoded, y)

    def test_numeric_labels(self):
        y = np.array([10, 20, 30])
        encoder = LabelEncoder()
        encoded = encoder.fit_transform(y)
        np.testing.assert_array_equal(encoded, [0, 1, 2])
