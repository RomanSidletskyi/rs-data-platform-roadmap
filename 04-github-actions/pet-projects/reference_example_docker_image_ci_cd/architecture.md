# Architecture

This solved example uses a two-path model:

1. pull request path -> test code and validate image build
2. trusted branch path -> build and publish immutable image tag

That split keeps speculative code and release automation separate.