# Solution

Object mapping:

- catalog is top-level governance boundary
- schema is a domain or subject subdivision
- table is a governed structured data object
- volume is a governed file access surface
- external location governs access to cloud storage paths

Environment reasoning:

- dev should allow experimentation with bounded risk
- prod should use stricter permissions and release flow

Identity reasoning:

- secrets should be governed centrally
- service identities should own automation paths rather than personal users