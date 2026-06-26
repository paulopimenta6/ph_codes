import numpy as np
import csv
import io
import pkgutil


def load_csv(filepath: str, delimiter: str = ",") -> tuple[np.ndarray, np.ndarray | None]:
    with open(filepath, "r") as f:
        reader = csv.reader(f, delimiter=delimiter)
        headers = next(reader, None)
        data = []
        for row in reader:
            if row:
                data.append([float(x) if x.strip() else 0.0 for x in row])
    data = np.asarray(data)

    if headers:
        return data, headers
    return data, None


def load_iris() -> tuple[np.ndarray, np.ndarray]:
    raw = pkgutil.get_data(__name__, "data/iris.csv")
    if raw is None:
        raise FileNotFoundError("iris.csv not found in package data")

    content = raw.decode("utf-8")
    reader = csv.reader(io.StringIO(content), delimiter=",")
    next(reader, None)

    X, y = [], []
    for row in reader:
        if row:
            X.append([float(v) for v in row[:-1]])
            y.append(row[-1].strip())

    return np.asarray(X), np.array(y)
