# Security and Governance Architecture

## Begin with Data and Trust Boundaries

Classify datasets and consumers before writing grants. Identify identities, operators, data owners, sensitive attributes, sharing partners, and administrative roles. Define which principals can create, read, change, share, and administer each data product.

## Role-Based Access Model

Use roles to represent job responsibilities and object ownership. Compose roles deliberately, keep administrative roles separate from daily-use roles, and grant the minimum required privileges at the narrowest sensible scope. Parent namespace usage and child object privileges are distinct. Decide how future objects receive grants and who owns grants after deployment.

Managed access schemas can centralize grant administration, which may reduce grant drift; they also require a clear release and ownership process. Test grants under real consumer roles rather than relying on an administrator session.

## Policy Layers

- **Secure views:** curated access interface and selected view protections.
- **Masking policies:** govern sensitive column values based on policy context.
- **Row access policies:** constrain visible rows.
- **Tags and classification:** make sensitivity and ownership discoverable.
- **Audit and access history:** support investigation and evidence.

These controls solve different problems and may be combined. Do not assume one policy protects paths through clones, exports, stages, other views, or broader grants.

## Identity and Integrations

Separate human and service identities. Prefer supported federation or key-based methods with controlled rotation over embedded credentials. Scope external storage integrations narrowly. Network policies and private connectivity can reduce exposure but may complicate developers, automation, and failover; validate actual client paths and operational support.

## Governance Operating Model

Policies need owners, review cadence, test data, exception process, and change control. Data classification should connect to grants, masking, retention, and sharing. Lineage without ownership or incident procedures is descriptive metadata, not governance by itself.

## Trade-Offs

- Central policy improves consistency but can slow teams without a clear self-service path.
- Domain ownership improves accountability but needs shared naming, classification, and review standards.
- Fine-grained controls reduce exposure but increase testing, policy-debugging, and support effort.
- Strong network isolation narrows attack paths but can hinder integrations and recovery if untested.

## Decision Checklist

- What data classifications and consumers exist?
- Which roles own data and which roles consume it?
- Are grants for existing and future objects intentional?
- Are sensitive fields protected at every access path?
- Can a consumer's permissions be tested automatically and audited?
- Who owns exceptions, policy changes, and periodic recertification?