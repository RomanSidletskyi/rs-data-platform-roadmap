# Expected Processed Output

Target CSV columns for the first iteration:

- `id`
- `name`
- `username`
- `email`
- `phone`
- `website`

## Rules

- preserve one row per source user object
- keep column order stable across runs
- do not silently invent missing values beyond `null` or empty-string strategy chosen in your implementation
- raw JSON should be saved even if CSV writing fails later