import unittest

from src.app import build_message


class AppTests(unittest.TestCase):
    def test_build_message(self):
        self.assertEqual(build_message("roadmap"), "hello from roadmap")


if __name__ == "__main__":
    unittest.main()