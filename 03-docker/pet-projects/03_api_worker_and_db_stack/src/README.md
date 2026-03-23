# Starter Notes For src

Implement the API and worker application code here.

Recommended minimum structure:

- one API entry point
- one worker entry point or loop
- one shared module for configuration and database logic

Recommended responsibilities:

- accept a job request
- persist job metadata
- process pending work
- store status or result updates