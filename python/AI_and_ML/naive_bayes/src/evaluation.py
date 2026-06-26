import numpy as np


def accuracy_score(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    y_true, y_pred = np.asarray(y_true), np.asarray(y_pred)
    return float(np.mean(y_true == y_pred))


def confusion_matrix(
    y_true: np.ndarray, y_pred: np.ndarray, labels: list | None = None
) -> np.ndarray:
    y_true, y_pred = np.asarray(y_true), np.asarray(y_pred)
    if labels is None:
        labels = np.unique(np.concatenate([y_true, y_pred]))
    else:
        labels = np.asarray(labels)

    label_to_idx = {l: i for i, l in enumerate(labels)}
    n = len(labels)
    matrix = np.zeros((n, n), dtype=np.int64)

    for t, p in zip(y_true, y_pred):
        i = label_to_idx[t]
        j = label_to_idx[p]
        matrix[i, j] += 1

    return matrix


def precision_score(
    y_true: np.ndarray,
    y_pred: np.ndarray,
    average: str = "binary",
    pos_label: int | str | None = None,
) -> float:
    y_true, y_pred = np.asarray(y_true), np.asarray(y_pred)
    labels = np.unique(np.concatenate([y_true, y_pred]))

    if average == "binary":
        if pos_label is None:
            pos_label = labels[-1] if len(labels) == 2 else labels[0]
        tp = np.sum((y_pred == pos_label) & (y_true == pos_label))
        fp = np.sum((y_pred == pos_label) & (y_true != pos_label))
        return float(tp / (tp + fp)) if (tp + fp) > 0 else 0.0

    elif average == "macro":
        precisions = []
        for l in labels:
            tp = np.sum((y_pred == l) & (y_true == l))
            fp = np.sum((y_pred == l) & (y_true != l))
            precisions.append(float(tp / (tp + fp)) if (tp + fp) > 0 else 0.0)
        return float(np.mean(precisions))

    elif average == "weighted":
        precisions = []
        weights = []
        for l in labels:
            tp = np.sum((y_pred == l) & (y_true == l))
            fp = np.sum((y_pred == l) & (y_true != l))
            precisions.append(float(tp / (tp + fp)) if (tp + fp) > 0 else 0.0)
            weights.append(float(np.sum(y_true == l)))
        total = sum(weights)
        return float(np.average(precisions, weights=weights)) if total > 0 else 0.0

    else:
        raise ValueError(f"Unsupported average: {average}")


def recall_score(
    y_true: np.ndarray,
    y_pred: np.ndarray,
    average: str = "binary",
    pos_label: int | str | None = None,
) -> float:
    y_true, y_pred = np.asarray(y_true), np.asarray(y_pred)
    labels = np.unique(np.concatenate([y_true, y_pred]))

    if average == "binary":
        if pos_label is None:
            pos_label = labels[-1] if len(labels) == 2 else labels[0]
        tp = np.sum((y_pred == pos_label) & (y_true == pos_label))
        fn = np.sum((y_pred != pos_label) & (y_true == pos_label))
        return float(tp / (tp + fn)) if (tp + fn) > 0 else 0.0

    elif average == "macro":
        recalls = []
        for l in labels:
            tp = np.sum((y_pred == l) & (y_true == l))
            fn = np.sum((y_pred != l) & (y_true == l))
            recalls.append(float(tp / (tp + fn)) if (tp + fn) > 0 else 0.0)
        return float(np.mean(recalls))

    elif average == "weighted":
        recalls = []
        weights = []
        for l in labels:
            tp = np.sum((y_pred == l) & (y_true == l))
            fn = np.sum((y_pred != l) & (y_true == l))
            recalls.append(float(tp / (tp + fn)) if (tp + fn) > 0 else 0.0)
            weights.append(float(np.sum(y_true == l)))
        total = sum(weights)
        return float(np.average(recalls, weights=weights)) if total > 0 else 0.0

    else:
        raise ValueError(f"Unsupported average: {average}")


def f1_score(
    y_true: np.ndarray,
    y_pred: np.ndarray,
    average: str = "binary",
    pos_label: int | str | None = None,
) -> float:
    p = precision_score(y_true, y_pred, average=average, pos_label=pos_label)
    r = recall_score(y_true, y_pred, average=average, pos_label=pos_label)
    return float(2 * p * r / (p + r)) if (p + r) > 0 else 0.0


def classification_report(
    y_true: np.ndarray, y_pred: np.ndarray
) -> str:
    y_true, y_pred = np.asarray(y_true), np.asarray(y_pred)
    labels = np.unique(np.concatenate([y_true, y_pred]))
    cm = confusion_matrix(y_true, y_pred, labels=labels)

    lines = ["Classification Report", "=" * 60]
    header = f"{'':>12} {'precision':>10} {'recall':>10} {'f1-score':>10} {'support':>10}"
    lines.append(header)
    lines.append("-" * 60)

    for i, l in enumerate(labels):
        tp = cm[i, i]
        fp = cm[:, i].sum() - tp
        fn = cm[i, :].sum() - tp
        support = int(cm[i, :].sum())

        prec = tp / (tp + fp) if (tp + fp) > 0 else 0.0
        rec = tp / (tp + fn) if (tp + fn) > 0 else 0.0
        f1 = 2 * prec * rec / (prec + rec) if (prec + rec) > 0 else 0.0

        lines.append(f"{str(l):>12} {prec:>10.3f} {rec:>10.3f} {f1:>10.3f} {support:>10}")

    lines.append("-" * 60)
    acc = accuracy_score(y_true, y_pred)
    lines.append(f"{'accuracy':>12} {'':>10} {'':>10} {acc:>10.3f} {len(y_true):>10}")
    lines.append("=" * 60)

    return "\n".join(lines)
