# Workflow Interface Notes

This reference example demonstrates a simple but important boundary:

- local workflow decides when validation happens
- reusable workflow decides how validation happens

That split keeps repository policy and reusable automation from collapsing into one file.