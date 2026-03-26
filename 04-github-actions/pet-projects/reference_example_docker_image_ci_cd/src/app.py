def build_message(name: str) -> str:
    normalized_name = name.strip() or "reference-example"
    return f"hello from {normalized_name}"


if __name__ == "__main__":
    print(build_message("docker-release"))