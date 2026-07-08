# MoonAuditChainKit

MoonAuditChainKit provides deterministic audit-event chain primitives for
MoonBit projects that need traceable operation logs, configuration change
records, CI step evidence, or data-governance provenance.

The core package is backend-neutral. It does not write files or call platform
APIs; users provide events, and the library builds a linked digest chain that
can be checked later.

Initial features:

- audit event model
- deterministic record digest
- append-only chain construction
- chain integrity verification
- first-broken-index detection
- compact JSON export
- CLI demo and regression tests
