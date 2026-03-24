# grep, find, xargs, sort, uniq, cut, awk, sed Cookbook

## Why This Topic Matters

These tools are the everyday extraction and inspection layer of shell work.

They are not academic extras.

They are how engineers answer questions quickly from logs, directories, configs, and codebases.

## Search With grep

Examples:

    grep -n ERROR app.log
    grep -i timeout app.log
    grep -r "TODO" .
    grep -E "error|failed|exception" app.log

Use grep when you know the text pattern you want.

## Search With find

Examples:

    find . -name "*.md"
    find . -type f
    find . -type f -size +10M
    find . -name "*.yml" -o -name "*.yaml"

Use find when the filesystem shape matters.

## Pass Results With xargs

Examples:

    find . -name "*.log" | xargs wc -l
    find . -name "*.py" | xargs grep -n "TODO"

Be careful with spaces in file names. Prefer null-separated patterns when needed.

## sort And uniq

Examples:

    cut -d',' -f3 data.csv | sort | uniq
    sort words.txt | uniq -c

Common pattern:

    command | sort | uniq -c | sort -nr

## cut

Examples:

    cut -d',' -f1,3 data.csv
    cut -d' ' -f1-4 app.log

## awk

Examples:

    awk '{print $1, $5}' app.log
    awk -F',' '{print $1, $3}' data.csv
    awk '/ERROR/ {print $0}' app.log

Use awk when field-based extraction is needed.

## sed

Examples:

    sed 's/dev/prod/g' config.txt
    sed -n '1,20p' app.log

Use sed for line-oriented substitution and printing.

## Realistic Scenario Examples

Find all workflow files in the repository:

    find . -path "*/.github/workflows/*.yml" -o -path "*/.github/workflows/*.yaml"

Find the most common error lines:

    grep ERROR app.log | sort | uniq -c | sort -nr | head

Find all Markdown files containing "GitHub Actions":

    find . -name "*.md" | xargs grep -n "GitHub Actions"

## Key Architectural Takeaway

These tools turn raw text and directory sprawl into inspectable, queryable signals.