import numpy as np
import pytest
from src.naive_bayes import GaussianNB, CategoricalNB


class TestGaussianNB:
    def test_fit_predict_binary(self):
        X = np.array([[1.0, 2.0], [2.0, 3.0], [5.0, 6.0], [6.0, 7.0]])
        y = np.array([0, 0, 1, 1])
        model = GaussianNB()
        model.fit(X, y)
        preds = model.predict(X)
        np.testing.assert_array_equal(preds, y)

    def test_predict_proba_shape(self):
        X = np.array([[1.0, 2.0], [5.0, 6.0]])
        y = np.array([0, 1])
        model = GaussianNB()
        model.fit(X, y)
        probs = model.predict_proba(X)
        assert probs.shape == (2, 2)

    def test_predict_proba_sums_to_one(self):
        X = np.array([[1.0, 2.0], [2.0, 3.0], [5.0, 6.0], [6.0, 7.0]])
        y = np.array([0, 0, 1, 1])
        model = GaussianNB()
        model.fit(X, y)
        probs = model.predict_proba(X)
        np.testing.assert_allclose(probs.sum(axis=1), np.ones(4))

    def test_multiclass(self):
        X = np.array(
            [
                [1.0, 2.0],
                [2.0, 3.0],
                [5.0, 6.0],
                [6.0, 7.0],
                [9.0, 10.0],
                [10.0, 11.0],
            ]
        )
        y = np.array([0, 0, 1, 1, 2, 2])
        model = GaussianNB()
        model.fit(X, y)
        preds = model.predict(X)
        np.testing.assert_array_equal(preds, y)

    def test_single_feature(self):
        X = np.array([[1.0], [2.0], [5.0], [6.0]])
        y = np.array([0, 0, 1, 1])
        model = GaussianNB()
        model.fit(X, y)
        preds = model.predict(X)
        np.testing.assert_array_equal(preds, y)

    def test_float64_conversion(self):
        X = np.array([[1, 2], [3, 4]], dtype=np.int64)
        y = np.array([0, 1])
        model = GaussianNB()
        model.fit(X, y)
        preds = model.predict(X)
        assert preds.dtype == np.int64 or preds.dtype == y.dtype

    def test_predict_before_fit_raises(self):
        model = GaussianNB()
        with pytest.raises(RuntimeError):
            model.predict(np.array([[1.0, 2.0]]))


class TestCategoricalNB:
    def test_fit_predict_binary(self):
        X = np.array([[0, 1], [0, 1], [1, 0], [1, 0]])
        y = np.array([0, 0, 1, 1])
        model = CategoricalNB(alpha=1.0)
        model.fit(X, y)
        preds = model.predict(X)
        np.testing.assert_array_equal(preds, y)

    def test_predict_proba_sums_to_one(self):
        X = np.array([[0, 1], [0, 1], [1, 0], [1, 0]])
        y = np.array([0, 0, 1, 1])
        model = CategoricalNB(alpha=1.0)
        model.fit(X, y)
        probs = model.predict_proba(X)
        np.testing.assert_allclose(probs.sum(axis=1), np.ones(4))

    def test_laplace_smoothing(self):
        X = np.array([[0], [0], [1]])
        y = np.array([0, 0, 1])
        model = CategoricalNB(alpha=1.0)
        model.fit(X, y)
        probs = model.predict_proba(np.array([[2]]))
        assert not np.any(np.isnan(probs))
        np.testing.assert_allclose(probs.sum(axis=1), np.ones(1))

    def test_multiclass(self):
        X = np.array([[0], [1], [2], [0], [1], [2]])
        y = np.array([0, 0, 1, 1, 2, 2])
        model = CategoricalNB(alpha=1.0)
        model.fit(X, y)
        preds = model.predict(np.array([[0], [1], [2]]))
        np.testing.assert_array_equal(preds, np.array([0, 0, 1]))

    def test_invalid_alpha(self):
        with pytest.raises(ValueError):
            CategoricalNB(alpha=-1.0)
