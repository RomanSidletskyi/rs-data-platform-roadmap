from pathlib import Path


def main() -> None:
    source = Path('config/profiles.example.yml')
    target = Path('.generated_profiles_note.txt')
    target.write_text(
        'Render profiles.yml from environment variables before running dbt.\n'
        f'Source template: {source}\n',
        encoding='utf-8',
    )


if __name__ == '__main__':
    main()