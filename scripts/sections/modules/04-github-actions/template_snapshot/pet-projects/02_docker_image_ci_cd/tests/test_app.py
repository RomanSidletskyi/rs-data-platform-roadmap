import unittest

from src.app import build_message


class AppTests(unittest.TestCase):
    def test_build_message(self):
        self.assertEqual(build_message("demo"), "hello from demo")

    def test_build_message_uses_default(self):
        self.assertEqual(build_message("   "), "hello from data-platform")


if __name__ == "__main__":
    unittest.main()