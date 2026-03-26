# 06 Environments, Security, And Deploys — Solution

## Protected Deploy Shape

```yaml
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - run: echo "validated"

  deploy:
    needs: validate
    runs-on: ubuntu-latest
    environment: prod
    steps:
      - run: echo "deploy after approval and validation"
```

## Secret Vs Variable Examples

- registry password -> secret
- cloud access key -> secret
- deployment region -> variable
- image repository name -> variable
- feature flag default -> variable

## Failure Analysis Note

Inspect in this order:

1. failing step logs
2. job boundaries before and after publish
3. artifact or tag used for deploy
4. environment approval and secret scope

One giant deploy step is weaker because it hides the exact failure boundary and makes rerun or rollback reasoning much harder.