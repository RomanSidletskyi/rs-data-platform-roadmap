# Least Privilege Inheritance And Common Misconfigurations

Least privilege sounds simple in principle and messy in practice.

ADLS makes that especially visible because storage paths often grow organically while permissions try to catch up afterward.

## Least Privilege Means Explicit Scope

Least privilege is not only about fewer permissions.

It is about assigning permissions at the smallest sensible boundary that still supports operations.

That requires:

- clear path ownership
- clear write and read scopes
- clear environment separation
- clear understanding of inherited access

This is why least privilege fails most often in lakes that were named or structured casually.

If boundaries are unclear, the platform has to choose between two weak options:

- grant broad access because nobody can identify the correct smaller scope
- create many exceptions at arbitrary subpaths that become impossible to reason about later

Good least-privilege design therefore depends on structure first and permissions second.

## Why Inheritance Helps And Hurts

Inheritance can reduce repetitive permission work.

That is useful.

But inheritance also means one broad assignment can unintentionally expose far more of the lake than intended.

Healthy governance uses inheritance deliberately, not blindly.

Inheritance is most useful when the parent path is already meaningful.

For example, inheritance can work well when:

- one domain owns a stable subtree
- child datasets share the same trust and lifecycle model
- the inherited scope matches how engineers actually operate the boundary

Inheritance becomes dangerous when:

- parent directories exist only because history accumulated there
- publish and internal paths sit under the same loosely governed parent
- nobody remembers which older grant is now propagating to newer folders

## Common Misconfigurations

Common failures include:

- granting wide access at the wrong parent directory
- forgetting how inherited permissions flow into child paths
- mixing emergency access with normal operational access
- allowing raw and publish zones to share the same broad writer groups
- keeping legacy permissions in place long after ownership changed

Another common misconfiguration is confusing troubleshooting convenience with a permanent operating model.

Examples:

- a broad grant was added during an incident and never removed
- a migration exception survives long after the migration ended
- one shared service principal continues to cross domain boundaries because splitting it now feels inconvenient

These are not just cleanup issues.

They are signs that access posture is drifting away from ownership posture.

## Practical Rule

If a team cannot explain why a permission exists at a specific parent path, the permission probably needs review.

An even stronger practical rule is:

- if a permission exists mainly because the path model is unclear, fix the path model before multiplying permission exceptions

## Good Versus Weak Security Posture

Weak posture:

- access works, so nobody wants to touch it

Healthy posture:

- access works, and the team can explain why that scope exists, who owns it, and which child paths inherit it

Another difference is reviewability.

Weak posture produces access that only the current operators understand.

Healthy posture produces access that a new engineer can audit without reconstructing years of local history.

## Practical Scenario

Suppose analysts need one published revenue dataset.

Instead of granting access to:

- `publish/finance/daily_revenue/`

the platform grants read access at a higher parent such as:

- `finance/`

because several finance datasets might be useful later.

This feels efficient.

It is usually a least-privilege failure.

The boundary has shifted from:

- what is currently supported

to:

- what might someday be convenient

That shift is how inherited overexposure becomes normalized.

## Decision Heuristics

Use these heuristics when reviewing inheritance:

- if the parent path has mixed internal and published meaning, inheritance is dangerous
- if child paths have different owners or consumer promises, inheritance is dangerous
- if access review depends on oral history, inheritance is dangerous
- if reducing scope would break real work, the boundary may be right
- if reducing scope would only break convenience, the grant is probably too broad

## Review Questions

1. Why is inheritance useful but dangerous in an unstructured lake?
2. What signals suggest least privilege has degraded over time?
3. Why is path design a prerequisite for sensible access control?
4. How do emergency exceptions quietly become permanent access posture?
5. Why is a convenient parent grant often weaker than a smaller supported-path grant?
