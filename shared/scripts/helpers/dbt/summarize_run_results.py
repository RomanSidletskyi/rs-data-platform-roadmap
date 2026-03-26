import json
from pathlib import Path


def main() -> None:
    path = Path('target/run_results.json')
    if not path.exists():
        print('run_results.json not found')
        return

    payload = json.loads(path.read_text(encoding='utf-8'))
    print(f"results: {len(payload.get('results', []))}")


if __name__ == '__main__':
    main()