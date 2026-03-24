# Architecture

## Delivery Model

- validation path: build only
- release path: build plus push

## Key Principle

The same event should not both validate speculative code and publish production-facing artifacts unless that boundary is explicitly intentional.

## Recommended Flow

1. PR arrives
2. image build is validated
3. merge happens
4. release workflow publishes commit-based tag

## Risks To Avoid

- publishing from pull requests
- using only `latest`
- mixing registry login and validation logic in the same uncontrolled trigger