# Project Template

Use this skeleton for every new end-to-end project. Copy the headings, keep the order, and replace the guidance lines.

## `README.md`

- Title: `P<nn> <Project name>`
- One-paragraph pitch: what is built and why it matters
- Target architecture: icon diagram `assets/architecture_azure.png` with caption, AWS variant in a collapsed block, Mermaid text version in a collapsed block (see [diagrams and images](conventions.md#diagrams-and-images))
- Reference from the source article: linked original diagram with source caption, plus one sentence on what this project changes
- Skills table: skill, where it is practiced
- Prerequisites: modules and deep dives to read first, accounts and tools
- Navigation table for the eight parts and the recommended route
- Cost warning with a link to [cost guardrails](cost_guardrails.md)

## `QUICKSTART.md`

- Numbered steps grouped as Install, Accounts and Access, Build, Run and Measure, Stop
- Every step: commands, then **Done when** with a check command, then a link to the matching `05` step
- One ingestion gate: new data must load without manual commands before building further
- AWS variant as a short replacement list for the cloud-specific steps
- Method: [how to run a project fast](how_to_run_a_project.md)

## `01_problem.md`

- Business context and stakeholders
- Source data: sample record, volume, delivery behavior
- Functional requirements
- Non-functional requirements: freshness, completeness, duplicates, replay window, security, cost
- Success metrics that can be measured
- Out of scope
- Diagram: context (`flowchart`, source to consumers)

## `02_architecture_decisions.md`

- Requirements that drive the design
- Options considered, with a diagram per option
- Trade-off table across options
- Why / why not Q&A: questions an interviewer or reviewer would ask
- ADRs: context, decision, consequences, rejected alternatives
- Latency budget per hop
- Failure modes: detection, impact, recovery
- Cost model
- Security and trust boundaries
- Diagrams: options, latency budget, failure sequence

## `03_snowflake_approach.md`

- Layer diagram with Snowflake objects
- Object inventory: object, type, purpose
- Feature choice per need, and the rejected feature
- Data model (Mermaid `erDiagram`)
- Automation graph (tasks, dynamic tables, pipes)
- What this project teaches about Snowflake

## `04_alternative_stacks.md`

- Component mapping table across stacks
- One architecture diagram per alternative
- When each alternative wins
- Learning roadmap linked to repository modules (Mermaid `flowchart` or `timeline`)

## `05_snowflake_step_by_step.md`

- Phases, each with steps
- For every step: what, why, how to verify, common errors
- Links to the matching `06_solution/` script
- Teardown at the end

## `06_solution/`

Follow the layout in [conventions](conventions.md#repository-layout-inside-06_solution). `README.md` gives the run order and expected results. Include `p<nn>.env.example` and `run_sql.sh` so every SQL script runs with `snow sql` and placeholders filled from the env file.

## `07_build_it_yourself.md`

- Brief written like a course assignment
- Rules: what you may and may not look at
- Milestones, each with goal, deliverables, acceptance criteria, and hints without code
- Stretch goals
- Final deliverables and review checklist
- Portfolio and interview section
- Diagram: milestone plan (Mermaid `gantt` or `flowchart`)
