import json


def load_config(config_path: str) -> dict:
    with open(config_path, "r", encoding="utf-8") as config_file:
        return json.load(config_file)
