# Command-Line Incident Cookbook

## Scenario 1 - Disk Feels Full

Commands:

    df -h
    du -sh ./* | sort -h

Goal:

- find which mount is full
- find which directory is consuming space

## Scenario 2 - Port Already In Use

Commands:

    lsof -i :8080
    ss -ltnp | grep 8080

Goal:

- identify which process owns the port

## Scenario 3 - SSH Does Not Connect

Commands:

    ping host
    nc -vz host 22
    ssh -v host

Goal:

- separate network issue, port issue, and auth issue

## Scenario 4 - Command Not Found

Commands:

    command -v tool
    echo "$PATH"
    type tool

Goal:

- identify PATH or install problem

## Scenario 5 - Permission Denied On Script

Commands:

    ls -l script.sh
    chmod +x script.sh
    head -n 1 script.sh

## Scenario 6 - Service Returns curl: (7)

Commands:

    nslookup host
    nc -vz host port
    curl http://host:port

Goal:

- locate whether failure is DNS, TCP, or application layer