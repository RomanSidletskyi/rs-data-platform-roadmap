# Solution

Representative command flow:

    mkdir -p sandbox/logs sandbox/data/raw sandbox/data/processed sandbox/scripts
    touch sandbox/logs/app.log sandbox/scripts/run.sh sandbox/data/raw/input.txt
    find sandbox | sort

Path reasoning example:

    pwd
    cd 00-shell-linux/simple-tasks/01_navigation_and_files
    pwd
    cd ../../..
    pwd

Safe mutation example:

    cp sandbox/data/raw/input.txt sandbox/data/raw/input.backup.txt
    mv sandbox/scripts/run.sh sandbox/scripts/bootstrap.sh
    rm sandbox/data/raw/input.backup.txt
    ls -la sandbox/scripts sandbox/data/raw