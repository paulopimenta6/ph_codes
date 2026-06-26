import numpy as np
from src.evaluation import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    confusion_matrix,
    classification_report,
)


class TestAccuracy:
    def test_perfect(self):
        y_true = np.array([0, 1, 0, 1])
        y_pred = np.array([0, 1, 0, 1])
        assert accuracy_score(y_true, y_pred) == 1.0

    def test_half(self):
        y_true = np.array([0, 1, 0, 1])
        y_pred = np.array([0, 0, 1, 1])
        assert accuracy_score(y_true, y_pred) == 0.5

    def test_all_wrong(self):
        y_true = np.array([0, 1])
        y_pred = np.array([1, 0])
        assert accuracy_score(y_true, y_pred) == 0.0


class TestConfusionMatrix:
    def test_binary(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 1, 0, 1])
        cm = confusion_matrix(y_true, y_pred)
        expected = np.array([[1, 1], [1, 1]])
        np.testing.assert_array_equal(cm, expected)

    def test_perfect(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 0, 1, 1])
        cm = confusion_matrix(y_true, y_pred)
        expected = np.array([[2, 0], [0, 2]])
        np.testing.assert_array_equal(cm, expected)

    def test_custom_labels(self):
        y_true = np.array(["a", "a", "b", "b"])
        y_pred = np.array(["a", "b", "a", "b"])
        cm = confusion_matrix(y_true, y_pred, labels=["a", "b"])
        expected = np.array([[1, 1], [1, 1]])
        np.testing.assert_array_equal(cm, expected)


class TestPrecision:
    def test_binary_perfect(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 0, 1, 1])
        assert precision_score(y_true, y_pred, average="binary", pos_label=1) == 1.0

    def test_binary_imperfect(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 1, 1, 0])
        assert precision_score(y_true, y_pred, average="binary", pos_label=1) == 0.5

    def test_macro(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 0, 1, 1])
        assert precision_score(y_true, y_pred, average="macro") == 1.0

    def test_weighted(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 0, 1, 1])
        assert precision_score(y_true, y_pred, average="weighted") == 1.0


class TestRecall:
    def test_binary_perfect(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 0, 1, 1])
        assert recall_score(y_true, y_pred, average="binary", pos_label=1) == 1.0

    def test_binary_imperfect(self):
        y_true = np.array([0, 1, 1, 1])
        y_pred = np.array([0, 1, 0, 1])
        assert recall_score(y_true, y_pred, average="binary", pos_label=1) == 2 / 3


class TestF1:
    def test_perfect(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 0, 1, 1])
        assert f1_score(y_true, y_pred, average="binary", pos_label=1) == 1.0

    def test_harmonic_mean(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 1, 1, 0])
        p = precision_score(y_true, y_pred, average="binary", pos_label=1)
        r = recall_score(y_true, y_pred, average="binary", pos_label=1)
        f1 = f1_score(y_true, y_pred, average="binary", pos_label=1)
        expected = 2 * p * r / (p + r)
        assert f1 == expected


class TestClassificationReport:
    def test_output_format(self):
        y_true = np.array([0, 0, 1, 1])
        y_pred = np.array([0, 0, 1, 1])
        report = classification_report(y_true, y_pred)
        assert "Classification Report" in report
        assert "precision" in report
        assert "recall" in report
        assert "f1-score" in report
        assert "support" in report
        assert "accuracy" in report
