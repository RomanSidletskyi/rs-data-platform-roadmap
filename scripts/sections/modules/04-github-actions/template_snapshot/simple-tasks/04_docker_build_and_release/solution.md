# 04 Docker Build And Release — Solution

## PR Validation Example

```yaml
jobs:
  docker-build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t local-check:pr .
```

## Publish Example

```yaml
jobs:
  publish:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.REGISTRY_USER }}
          password: ${{ secrets.REGISTRY_PASSWORD }}
      - run: |
          docker build -t ghcr.io/org/project:${{ github.sha }} .
          docker push ghcr.io/org/project:${{ github.sha }}
```

## Tag Strategy Notes

- use `${{ github.sha }}` as an immutable tag
- optionally add `main` or `latest` as a convenience tag
- never rely only on `latest` for rollback or traceability