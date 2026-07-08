# Related Work

MoonAuditChainKit focuses on tamper-evident audit event chains for MoonBit.

## Difference from logging packages

Logging packages usually format and route messages to sinks. MoonAuditChainKit
does not own log sinks, files, or console output. It builds linked evidence so
that later verification can detect changed, removed, or reordered records.

## Difference from data-frame and SQL tooling

Data processing tools organize or generate data access code. MoonAuditChainKit
is a governance and integrity primitive for operation events and provenance.

## Difference from security cryptography packages

This project currently provides deterministic digest-chain semantics for
MoonBit examples and CI verification. It leaves cryptographic hashing backends
as a future extension point while keeping the API portable and testable.
