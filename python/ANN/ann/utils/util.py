from typing import List
from matth import exp


def dot_product(xs: List[float], ys: List[float]) -> float:
    """Faz o produto escalar entre dois vetores."""
    return sum(x*y for x, y in zip(xs, ys))