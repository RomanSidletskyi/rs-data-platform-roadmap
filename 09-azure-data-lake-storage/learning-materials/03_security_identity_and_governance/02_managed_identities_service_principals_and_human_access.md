# Managed Identities Service Principals And Human Access

Identity choice is one of the most practical ADLS governance decisions.

A platform with weak identity choices becomes hard to secure and hard to troubleshoot.

## Human Access

Human access is necessary for some operational and investigative work.

But humans should not be the default runtime identity for production flows.

If pipelines depend on personal access patterns, the system is already fragile.

## Service Principals

Service principals are useful for automation and application-driven access.

They are often used by:

- CI/CD workflows
- external tools
- integration jobs
- controlled application services

But teams misuse them when one broad service principal ends up owning many unrelated workflows.

That creates hidden blast radius.

## Managed Identities

Managed identities are often the cleaner option for Azure-native workloads.

They reduce secret-handling burden and fit better with platform-managed services.

This can be especially attractive when workloads run in Azure-hosted compute environments.

## Group-Based Human Access

For people, group-based access is usually stronger than direct individual assignments.

That improves:

- auditability
- onboarding and offboarding
- consistency
- operational clarity

## Good Versus Weak Practice

Weak practice:

- one shared service principal for many teams
- developers using personal identities for recurring production writes
- access exceptions managed manually with no clear model

Stronger practice:

- managed identities where Azure-native runtime supports them
- distinct service principals where separation is needed
- group-driven human access
- clear difference between operational troubleshooting access and production write identities

## Review Questions

1. When is a managed identity usually preferable to a secret-bearing service principal?
2. What risks come from shared automation identities across many workloads?
3. Why should production write paths rarely depend on human identities?
