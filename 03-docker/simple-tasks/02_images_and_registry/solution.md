# Solution - Images And Registry

This topic builds the artifact model behind Docker.

## Task 1 — Pull An Image From Registry

```bash
docker pull python:3.12-slim
docker images
```

A registry is a remote system that stores images. Docker Hub is the default public example many learners use first.

## Task 2 — Compare Image Tags

Examples:

- `python:3.12-slim`
- `python:3.12-alpine`

Pinned tags help reproducibility. `latest` is convenient for quick experiments, but weak for repeatable setups.

## Task 3 — List Local Images

```bash
docker images
docker history python:3.12-slim
```

Important fields:

- repository
- tag
- image id
- size

## Task 4 — Reuse One Image For Multiple Containers

```bash
docker run -d --name web-a -p 8081:80 nginx:alpine
docker run -d --name web-b -p 8082:80 nginx:alpine
docker ps
```

Two containers can run from one image because the image is the shared artifact, while each container gets its own runtime state.

## Task 5 — Explain Image Vs Container

One clear answer:

- an image is a packaged, reusable artifact
- a container is a running instance created from that artifact

For example, `nginx:alpine` is an image. `web-a` and `web-b` are two containers created from that same image.

## Common Mistakes

- assuming deleting one container deletes the image
- assuming `latest` means stable or reproducible
- forgetting that tags represent different artifact variants

## Definition Of Done

This topic is complete if you can:

- pull and list images
- explain what a registry is
- compare tags meaningfully
- run multiple containers from one image
- explain artifact vs runtime instance clearly