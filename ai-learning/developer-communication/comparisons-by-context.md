# Communication By Context

This guide helps you choose the right communication artifact for the situation.

The problem is often not only how to write better.

The earlier mistake is choosing the wrong format for the job.

## Quick Mapping

| Context | Best Artifact | Main Goal | Wrong Default |
| --- | --- | --- | --- |
| Bug or failure needs investigation | issue | establish scope, impact, and next action | vague chat message |
| Code change is ready for review | PR description | reduce reviewer guesswork | one-line summary |
| Architectural choice affects future design | ADR or architecture note | capture decision and trade-offs | buried Slack thread |
| Design is still being challenged | design review note | expose assumptions and risks early | jumping straight into implementation |
| Reviewer asks why a decision was made | review reply | answer directly and explain rationale | defensive response |
| You need to explain system behavior aloud | spoken explanation | create shared mental model fast | low-structure rambling |

## Artifact Selection Rules

### Use An Issue When

- something is broken, unclear, or needs triage
- multiple people may need a shared problem statement
- impact, scope, or ownership must be clarified

Do not use an issue as a substitute for an ADR or design proposal.

An issue describes a problem to investigate or resolve.

It does not replace a decision record.

### Use A PR Description When

- code already exists and is ready for review
- reviewers need change context, risk, and validation details
- you want to reduce back-and-forth in review

Do not use a PR description to introduce an unreviewed architectural decision for the first time.

If the decision is substantial, link to an ADR, issue, or design note.

### Use An ADR Or Architecture Note When

- you are choosing between meaningful technical options
- future readers will need to understand why the decision happened
- the trade-off matters beyond one code diff

Do not hide architecture decisions inside PR text only.

PRs explain a change.

ADRs explain why one long-lived direction was chosen.

### Use A Design Review Note When

- the design is not settled yet
- you need feedback before implementation cost gets high
- the goal is to surface assumptions, risks, and failure modes

Do not wait until code review to ask design-level questions that should have been discussed earlier.

### Use A Review Reply When

- a reviewer asked for reasoning, clarification, or follow-up
- you need to explain a trade-off without rewriting the whole PR
- the answer should be short, direct, and tied to the actual code path

Do not turn review replies into vague status updates.

Answer the question first.

Then add evidence or follow-up if needed.

### Use A Spoken Explanation When

- someone needs a fast model of the system
- you are in an interview, design discussion, or sync call
- the listener needs flow, boundaries, and one key trade-off

Do not speak as if you are reading documentation aloud.

Spoken explanations need stronger structure and simpler wording.

## Comparison Matrix

| Artifact | Audience | Time Horizon | What Must Be Explicit | Common Failure |
| --- | --- | --- | --- | --- |
| issue | on-call engineer, teammate, lead | short to medium | scope, impact, known vs unknown, reproduction | reporting symptoms without triage context |
| PR description | reviewer, maintainer | short | what changed, why, risk, validation, review focus | describing files changed without explaining intent |
| ADR | architect, team, future maintainer | medium to long | constraints, options, decision, trade-offs, consequences | pretending the chosen option had no real downside |
| design review note | peers, leads, stakeholders | medium | assumptions, open questions, risks, alternatives | presenting implementation as already fixed |
| review reply | reviewer | immediate | direct answer, rationale, next action if needed | sounding defensive or evasive |
| spoken explanation | interviewer, reviewer, teammate | immediate | problem, components, flow, trade-off | rambling without a clear system boundary |

## Decision Heuristics

Ask these questions in order:

1. Am I describing a problem, a change, or a decision?
2. Does the audience need action, review, or alignment?
3. Is this mostly for now, or does future reasoning need to be preserved?
4. Does the content contain uncertainty, risk, or trade-offs that must be visible?

Use the answers to pick the artifact:

- problem plus triage: issue
- implemented change plus review: PR description
- long-lived technical choice: ADR
- unresolved design needing feedback: design review note
- narrow response to reviewer feedback: review reply
- fast verbal alignment: spoken explanation

## Practical Rule

When communication quality is low, engineers often try to make one artifact do every job.

That usually creates confusion.

Choose the right artifact first.

Then improve the quality inside that artifact.