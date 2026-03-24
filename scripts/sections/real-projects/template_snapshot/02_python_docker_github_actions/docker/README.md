# Docker Notes

Build the image from the project root:

```bash
docker build -f docker/Dockerfile -t python-docker-github-actions:local .
```

Run the pipeline in the container:

```bash
docker run --rm python-docker-github-actions:local
```

Override the command if you want a different run mode:

```bash
docker run --rm python-docker-github-actions:local python run_pipeline.py --run-mode extract
```