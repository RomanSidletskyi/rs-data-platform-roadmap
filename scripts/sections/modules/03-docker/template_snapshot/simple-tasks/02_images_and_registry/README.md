# Images And Registry

## Task 1 — Pull An Image From Registry

### Goal

Understand how images arrive on the local machine.

### Input

Use a public image such as `python:3.12-slim`.

### Requirements

- pull the image
- confirm it exists locally
- explain what a registry is

### Expected Output

A pulled image available in the local image list.

### Extra Challenge

Compare the result with another image such as `nginx:alpine`.

## Task 2 — Compare Image Tags

### Goal

Build version-awareness.

### Input

Choose two tags of the same image family.

### Requirements

- compare two image tags
- explain why explicit version tags are safer than `latest`
- describe when `latest` is still acceptable in learning work

### Expected Output

A short comparison of two image tags.

### Extra Challenge

Inspect the size difference between two tags.

## Task 3 — List Local Images

### Goal

Inspect the local artifact store.

### Input

At least two local images.

### Requirements

- list local images
- identify repository, tag, and size
- explain which values matter when choosing an image

### Expected Output

A readable list of local images with a short interpretation.

### Extra Challenge

Use image history to inspect layers.

## Task 4 — Reuse One Image For Multiple Containers

### Goal

Understand that one image can produce multiple runtime instances.

### Input

Use `nginx:alpine`.

### Requirements

- start two containers from the same image
- use different host ports
- explain why this does not duplicate the image conceptually

### Expected Output

Two running containers based on one image.

### Extra Challenge

Stop one container and explain what remains on the system.

## Task 5 — Explain Image Vs Container

### Goal

Strengthen conceptual clarity.

### Input

Your own comparison.

### Requirements

- explain image vs container in your own words
- include at least one real example from previous tasks
- mention artifact vs runtime instance

### Expected Output

A concise but clear conceptual explanation.

### Extra Challenge

Add a note about layers and cache.