# RBAC ACL And Identity Mental Model

Many teams struggle with ADLS security because they mix Azure RBAC and POSIX-like ACL thinking without a clear model.

That confusion creates both over-permissioning and broken pipelines.

## Start With The Layers

A useful mental model has three parts:

- identity: who is acting
- control plane authorization: what Azure resource actions are allowed through RBAC
- data plane path access: what data paths can be read or written through ACLs and storage permissions

If you skip this layered view, troubleshooting access becomes chaotic.

## RBAC

RBAC is useful for broad Azure resource-level permissions.

It helps answer questions like:

- who can manage the storage account?
- who can assign permissions?
- which service principal can access storage resource capabilities at a broad scope?

RBAC is important, but it is often too coarse if used alone for fine-grained dataset access.

## Azure Example

Imagine these three responsibilities:

- platform administrators manage the storage account
- an ingestion managed identity writes to `raw/crm/salesforce/accounts/`
- a finance analytics group reads only `publish/finance/daily_revenue/`

Treating all three with one broad RBAC assignment at storage-account scope is weak.

It may work technically, but it ignores real operational boundaries.

In practice, a healthier pattern is usually:

- RBAC for broad resource access and administration
- ACLs for path-level read and write scope
- distinct identities or groups for each responsibility

## ACLs

ACLs matter when you need directory and file-level control.

This is where you can express ideas like:

- this engineering job can write to one raw path
- this consumer can only read one publish directory tree
- this team can manage one domain subtree but not another

ACLs make the storage layout operationally meaningful.

## Scenario Matrix

Think about the difference like this:

| Need | Better primary mechanism | Why |
| --- | --- | --- |
| manage storage account settings | RBAC | this is an Azure resource responsibility |
| grant one pipeline write access to a raw subtree | ACLs plus correct identity | the boundary is path-specific |
| allow analysts to read one published dataset | ACLs plus group identity | read scope should be narrower than resource-wide access |
| let platform team audit and administer storage broadly | RBAC | administrative control is intentionally broad |

The exact Azure role combination can vary by organization.

The architectural point does not change:

- broad platform administration and narrow dataset access are different problems

## Identity Is The First Decision

Before deciding RBAC versus ACL detail, decide which identity should act:

- human user
- service principal
- managed identity
- group-based access through Entra ID

A weak platform solves everything with broad shared service principals.

A stronger platform treats identity design as part of governance.

## Troubleshooting Rule Of Thumb

When access fails, do not ask only:

- does this identity have permission?

Also ask:

- is this the right identity?
- is the intended boundary resource-level or path-level?
- did inheritance grant or block access unexpectedly?
- is a broad RBAC assignment hiding an ACL design issue?

Troubleshooting becomes much faster when teams know which layer they are actually debugging.

## Healthy Mental Model

Use RBAC for broad Azure-level control.

Use ACLs for directory and path-level data access.

Use well-defined identities so access can be reasoned about and audited.

## Weak Versus Healthy Security Thinking

Weak thinking:

- give the pipeline full access first and narrow it later

Healthy thinking:

- choose the runtime identity, choose the narrowest stable path boundary, then grant access deliberately at the right layer

## Review Questions

1. Why is RBAC alone often too broad for dataset-level control?
2. Why are ACLs meaningful only when path structure is well designed?
3. What problems appear when identity design is vague before permissions are assigned?
