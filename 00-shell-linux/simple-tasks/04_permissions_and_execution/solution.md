# Solution

Example flow:

    printf '#!/usr/bin/env bash\necho hello\n' > hello.sh
    ls -l hello.sh
    chmod +x hello.sh
    ./hello.sh

Mode comparison:

    chmod 644 notes.txt
    chmod 755 hello.sh
    ls -l notes.txt hello.sh

Debug checklist:

- inspect with `ls -l`
- confirm executable bit
- inspect shebang with `head -n 1`
- run with explicit interpreter if needed: `bash hello.sh`