# Solution

File inspection example:

    head -n 5 README.md
    tail -n 10 README.md
    wc -l README.md

Split stdout and stderr example:

    ls README.md missing-file.txt > out.txt 2> err.txt

Combined output example:

    ls README.md missing-file.txt > combined.log 2>&1
    tail -n 20 combined.log