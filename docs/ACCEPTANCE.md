# Acceptance Notes

Current acceptance surface:

- audit event model
- deterministic event canonicalization
- digest-linked audit records
- append-only chain construction
- chain verification report
- first broken index detection
- chain proof summary
- JSON export helpers
- CLI demo
- regression tests
- GitHub Actions CI

Useful commands:

```powershell
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon test --target js
moon run cmd/main
```
