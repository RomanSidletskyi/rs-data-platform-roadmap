# Prompting Guides

These guides focus on high-signal prompts for technical work.

They are meant to improve clarity, not increase output volume.

The goal is not to collect clever prompt wording.

The goal is to ask questions that produce better reasoning, stronger validation, and more useful next actions.

## What This Directory Is For

Use these guides when you already know the kind of work you are doing, but want to improve the quality of the interaction.

These files are most useful for:

- framing learning questions more precisely
- debugging with clearer hypotheses
- reviewing code with better risk focus
- comparing architectures with explicit trade-offs

## Included Guides

- `learning-prompts.md`: prompts for explanation, concept checks, and study support
- `debugging-prompts.md`: prompts for isolating failures and testing hypotheses
- `code-review-prompts.md`: prompts for finding risks, regressions, and missing validation
- `architecture-prompts.md`: prompts for trade-offs, boundaries, and design alternatives

## If You Want X, Start Here

If you want better explanations and study prompts:

1. `learning-prompts.md`
2. `../workflows/how-to-learn-faster.md`
3. `../practical-exercises/README.md`

If you want stronger debugging prompts:

1. `debugging-prompts.md`
2. `../workflows/ai-for-debugging.md`
3. `../practical-exercises/04_ai_code_review/README.md`

If you want better review prompts:

1. `code-review-prompts.md`
2. `../developer-communication/review-communication-comparison.md`
3. `../practical-exercises/04_ai_code_review/README.md`

If you want better architecture and trade-off prompts:

1. `architecture-prompts.md`
2. `../workflows/ai-for-project-design.md`
3. `../practical-exercises/03_ai_pipeline_design/README.md`

## Prompt Selection Heuristic

Choose the prompt guide by the type of uncertainty:

- concept uncertainty -> `learning-prompts.md`
- failure uncertainty -> `debugging-prompts.md`
- quality and risk uncertainty -> `code-review-prompts.md`
- boundary and trade-off uncertainty -> `architecture-prompts.md`

If the answer needs facts from code, logs, or outputs, the prompt is only the start.

You still need evidence from the real artifact.

## Practice Map

These guides work best when paired with the exercise layer:

- `learning-prompts.md` -> `../practical-exercises/01_ai_python_refactor/README.md`
- `learning-prompts.md` -> `../practical-exercises/02_ai_sql_generation/README.md`
- `architecture-prompts.md` -> `../practical-exercises/03_ai_pipeline_design/README.md`
- `debugging-prompts.md` -> `../practical-exercises/04_ai_code_review/README.md`
- `code-review-prompts.md` -> `../practical-exercises/04_ai_code_review/README.md`

The prompt guide improves the question.

The exercise shows whether the answer survives review and validation.

## Good Prompt Standard

Stronger prompts usually include:

- the exact task
- the relevant constraints
- the expected output shape
- the main failure mode to watch for
- a request for trade-offs, assumptions, or validation steps

## Rule

Prefer prompts that expose constraints, inputs, expected outputs, and failure modes.

Weak prompts produce generic answers.

Do not treat prompt quality as a substitute for technical judgment.