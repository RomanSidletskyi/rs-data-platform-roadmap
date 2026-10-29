# What A Catalog Is And Why It Exists

## 1. Catalog Is The Control Plane

If you only remember one thing about Iceberg architecture, remember this:

- the catalog is the control plane

Storage holds bytes.

Metadata describes the table.

The catalog tells engines where the current table metadata lives.

## 2. What A Catalog Actually Does

A catalog typically does these jobs:

- map table name to current metadata location
- help coordinate commit publication
- provide namespace and object discovery
- expose the official table identity for engines

Depending on implementation, the catalog may also influence:

- access model
- service boundaries
- how engines authenticate
- how commit conflicts are mediated or retried

That means the catalog is much more than a convenience registry.

## 3. Why The Catalog Is Often More Important Than People Expect

Many engineering discussions focus on file format and ignore the catalog.

That is a mistake because the catalog defines:

- who owns the table namespace
- how engines find current state
- which control plane is authoritative
- how multi-engine interoperability is operationalized

Two platforms can both use Iceberg and still have very different architectures because their catalogs and ownership models are different.

## 4. Why It Matters So Much

Without a stable catalog, teams end up with questions like:

- who decides the current table version?
- how do engines discover tables consistently?
- how do commits avoid conflicting publication?

Those are platform questions, not only file questions.

This is also why teams often underestimate migration difficulty.

Moving files is not the same thing as moving metadata authority.

## 5. Common Misunderstanding

Many beginners think the catalog is secondary and the files are primary.

Architecturally, that is incomplete.

The correct view is:

- files are storage assets
- metadata files define table state
- catalog is the official entrypoint to that state

## 6. Catalog Choice Changes The Whole Operating Model

If the catalog is Glue, the platform often inherits AWS-centric assumptions.

If the catalog is a REST catalog, the platform may become more explicitly service-oriented.

If the catalog is a managed service with RBAC and service principals, governance model changes as well.

So catalog choice affects not only setup, but also:

- ownership boundaries
- access-control style
- engine onboarding
- operational debugging

## 7. Why Catalog Choice Is An Architecture Decision

Catalog choice affects:

- ownership
- access patterns
- interoperability
- governance model
- engine support
- operational complexity

This is why catalog selection belongs in architecture review, not only in engineering setup notes.