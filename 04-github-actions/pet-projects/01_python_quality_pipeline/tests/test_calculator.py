import unittest

from src.calculator import mean


class CalculatorTests(unittest.TestCase):
    def test_mean_for_integers(self):
        self.assertEqual(mean([1, 2, 3]), 2.0)

    def test_mean_rejects_empty_values(self):
        with self.assertRaises(ValueError):
            mean([])


if __name__ == "__main__":
    unittest.main()