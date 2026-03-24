# Images, Containers, And Registry

## Why This Topic Matters

Many Docker misunderstandings come from mixing up images and containers. If this distinction is weak, debugging and system design both become harder.

## Core Concepts

- image: immutable packaged artifact
- container: runtime instance of an image
- tag: human-friendly version label for an image
- registry: remote image storage such as Docker Hub or another registry service
- layer: filesystem step reused across image builds

## How It Works

An image is built in layers. Each Dockerfile instruction such as `RUN`, `COPY`, or `ADD` typically creates a new layer. Docker reuses cached layers when possible.

A container adds a writable runtime layer on top of the image. Multiple containers can run from the same image at the same time.

## Practical Commands

Pull and inspect images:

```bash
docker pull python:3.12-slim
docker pull nginx:alpine
docker images
docker history python:3.12-slim
```

Create two containers from one image:

```bash
docker run -d --name web-1 -p 8081:80 nginx:alpine
docker run -d --name web-2 -p 8082:80 nginx:alpine
docker ps
```

Clean up:

```bash
docker stop web-1 web-2
docker rm web-1 web-2
```

## Versioning Notes

Pinned tags are usually safer than `latest` because they make your environment more predictable. For learning, `latest` is convenient. For repeatable engineering work, explicit versions are better.

## Common Mistakes

- saying “container” when the real issue is the image version
- reusing `latest` everywhere and losing reproducibility
- assuming deleting a container removes the image
- not understanding that multiple containers can share the same image artifact

## Architectural View

Images behave like deployable artifacts. Containers behave like runtime instances. This matters because production systems move artifacts through environments, not raw source folders.

Once you understand this, Docker becomes less about commands and more about controlled artifact delivery.

## Trade-Offs

Image-based delivery improves consistency, but also means you must think about:

- image size
- dependency surface area
- version pinning
- registry access
- rebuild strategy

## How It Connects To Data Engineering

Data engineers often work with tools that are distributed as images. Knowing how image versioning works helps you:

- keep local stacks stable
- avoid hidden dependency drift
- reproduce issues on another machine
- share a working environment with teammates

## What To Practice Next

After this topic, practice:

- comparing image tags
- listing local images
- inspecting image history
- running multiple containers from one image