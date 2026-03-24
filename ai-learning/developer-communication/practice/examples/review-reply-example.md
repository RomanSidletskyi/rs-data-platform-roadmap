# Review Reply Example

## Scenario

A reviewer asked why the pipeline now fails earlier for missing required fields.

## Weak Version

I changed it because I think failing earlier is cleaner.

The tests passed, so it should be okay.

## Why This Is Weak

- it sounds subjective instead of reasoned
- it does not answer the trade-off clearly
- the tone can read as dismissive
- the reviewer still does not know where to challenge the decision

## Strong Version

Yes, the pipeline now fails earlier by design.

We moved the required-field checks into the validation step so invalid inputs stop before transformation starts.

The trade-off is that we lose any partial downstream progress for those invalid files, but the failure mode becomes much easier to diagnose and prevents us from constructing partially trusted records.

I added tests around the early-failure behavior and around optional unknown fields so the validation boundary is explicit rather than accidental.

If you think the required-field list is too strict, the main place to challenge is the validation rule set rather than the transformation step.

## Why This Is Strong

- it answers the reviewer immediately
- it explains both the rationale and the downside
- it shows where a follow-up discussion should focus