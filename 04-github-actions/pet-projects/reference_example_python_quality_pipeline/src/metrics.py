def normalize_numbers(values):
    return [float(value) for value in values]


def average(values):
    normalized = normalize_numbers(values)
    if not normalized:
        raise ValueError("values must not be empty")
    return sum(normalized) / len(normalized)


def maximum(values):
    normalized = normalize_numbers(values)
    if not normalized:
        raise ValueError("values must not be empty")
    return max(normalized)