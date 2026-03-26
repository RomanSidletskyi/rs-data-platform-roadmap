import unittest

from src.metrics import average, maximum


class MetricsTests(unittest.TestCase):
    def test_average(self):
        self.assertEqual(average([2, 4, 6]), 4.0)

    def test_maximum(self):
        self.assertEqual(maximum([2, 4, 6]), 6.0)

    def test_average_rejects_empty(self):
        with self.assertRaises(ValueError):
            average([])


if __name__ == "__main__":
    unittest.main()