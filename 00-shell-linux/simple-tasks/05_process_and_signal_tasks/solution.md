# Solution

Background process example:

    sleep 300 &
    jobs
    pgrep -fl sleep
    kill <pid>

Port inspection examples:

    lsof -i :8080
    ss -ltnp | grep 8080

Reasoning:

- use `kill` first for graceful termination
- use `kill -9` only when the process refuses to stop and you understand the risk