# Solution

Find markdown files:

    find 00-shell-linux -name "*.md" | sort

Search text:

    grep -Rni "Docker" docs

Pipeline example:

    grep -n "Module:" docs/learning-sequence.md
    grep -n "Module:" docs/learning-sequence.md | wc -l