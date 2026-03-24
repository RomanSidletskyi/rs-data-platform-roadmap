def build_message(name: str) -> str:
    normalized_name = name.strip() or "data-platform"
    return f"hello from {normalized_name}"


if __name__ == "__main__":
    print(build_message("github-actions"))