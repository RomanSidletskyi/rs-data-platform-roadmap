# AI English For Developers

## Goal

Improve English through real developer tasks instead of isolated language drills.

## Read Before

- `../../workflows/english-for-developers.md`
- `../../language-learning/english-for-developers-stack.md`
- `../../comparisons/language-tools-by-task.md`

## Read After

- `../../developer-communication/speaking-about-systems.md`
- `../../developer-communication/practice/speaking-about-systems-exercise.md`
- `../../personal-operating-model/daily-routine.md`
- `../../personal-operating-model/weekly-review.md`

## Tasks

1. Read one technical text in English.
2. Extract useful phrases, not just words.
3. Store the best phrases in a review system.
4. Explain the text aloud in English.
5. Rewrite a short technical note in better English.

## Deliverable

Produce:

- one vocabulary list of useful phrases
- one spoken explanation outline
- one improved written note

## Rule

The target is clearer developer communication, not just higher app scores.

## Evaluation Sheet

Score the final output from 1 to 5:

- usefulness of phrases: are the extracted phrases reusable in real technical work
- spoken clarity: can you explain the topic aloud in simple English
- writing quality: is the rewritten note clearer and more natural
- technical accuracy: did English improvement preserve the meaning
- transfer value: can you use what you learned in a real issue, PR, meeting, or interview

Use this interpretation:

- 1-2: mostly passive study with little transfer to real work
- 3: useful but still generic or hard to reuse
- 4: strong developer-oriented language practice
- 5: directly reusable in technical communication

## Worksheet Template

### Source Material

Title or link:

Topic:

### Useful Phrases

- phrase 1:
- phrase 2:
- phrase 3:
- phrase 4:
- phrase 5:

### Spoken Explanation Outline

Problem:

Main idea:

Key terms:

One trade-off or limitation:

### Improved Written Note

Original version:

Improved version:

### Personal System Capture

Decision journal entry:

Mistake to log:

### Scorecard

- usefulness of phrases: __/5
- spoken clarity: __/5
- writing quality: __/5
- technical accuracy: __/5
- transfer value: __/5

Lowest score and why:

Evidence for the score:

### Reflection

- which phrases are worth reusing:
- what was hard to explain aloud:
- what AI improved well:
- what sounded natural but changed the meaning:

## Filled Example

### Source Material

Title or link:

Delta Lake schema evolution overview

Topic:

How schema evolution helps teams accept safe table changes without rewriting entire pipelines

### Useful Phrases

- schema evolution allows compatible changes over time
- downstream consumers depend on stable contracts
- uncontrolled changes can break data reliability
- the trade-off is flexibility versus predictability
- operational simplicity matters in day-to-day maintenance

### Spoken Explanation Outline

Problem:

data schemas change over time and pipelines need a safe way to handle those changes

Main idea:

schema evolution lets a table accept some compatible changes without full manual rebuilds

Key terms:

schema evolution, downstream consumers, data contract, compatibility

One trade-off or limitation:

too much flexibility can hide poor contract discipline

### Improved Written Note

Original version:

Schema evolution is useful because it lets us change tables easier and pipelines continue to work.

Improved version:

Schema evolution is useful because it allows compatible table changes over time while reducing unnecessary pipeline rewrites.

The trade-off is that flexibility must still be controlled, or downstream consumers may see unstable data contracts.

### Personal System Capture

Decision journal entry:

Store reusable technical phrases, not isolated vocabulary, and connect reading practice to speaking and writing on the same topic.

Mistake to log:

Natural-sounding rewrites can still weaken meaning if the trade-off or contract language becomes too vague.

### Example Scorecard

- usefulness of phrases: 5/5
- spoken clarity: 4/5
- writing quality: 4/5
- technical accuracy: 5/5
- transfer value: 4/5

Lowest score and why:

Spoken clarity is not 5 because the explanation outline is still abstract and would benefit from one concrete example.

Evidence for the score:

The key ideas are reusable in a real engineering conversation, but the outline does not yet anchor the explanation in one realistic pipeline case.

### Example Reflection

- which phrases are worth reusing: stable contracts, compatibility, flexibility versus predictability
- what was hard to explain aloud: how to describe compatibility without sounding too theoretical
- what AI improved well: it made the sentence more natural while preserving the engineering meaning
- what sounded natural but changed the meaning: phrases like easier changes were too vague and needed to be replaced with compatible changes