///|
test "audit event canonical format is stable" {
  let event = AuditEvent::new("alice", "update", "config", 1000, "v=2")
  assert_eq(event.canonical(), "alice|update|config|1000|v=2")
}

///|
test "digest text is deterministic" {
  assert_eq(digest_text("abc"), digest_text("abc"))
  assert_true(digest_text("abc") != digest_text("abd"))
}

///|
test "audit record links previous digest into current digest" {
  let event = AuditEvent::new("alice", "update", "config", 1000, "v=2")
  let record = AuditRecord::new(1, "genesis", event)
  assert_eq(record.previous_digest, "genesis")
  assert_true(record.valid())
  assert_eq(record.digest, record.recompute_digest())
}

///|
test "audit chain appends records with linked digest" {
  let chain = AuditChain::new("config")
    .append(AuditEvent::new("alice", "create", "flag", 1000, "on"))
    .append(AuditEvent::new("bob", "update", "flag", 1100, "off"))
  assert_eq(chain.length(), 2)
  assert_eq(chain.records[0].previous_digest, "genesis")
  assert_eq(chain.records[1].previous_digest, chain.records[0].digest)
  assert_eq(chain.head_digest(), chain.records[1].digest)
}

///|
test "audit chain verifies intact records" {
  let chain = AuditChain::new("ops")
    .append(AuditEvent::new("alice", "deploy", "api", 1000, "v1"))
    .append(AuditEvent::new("alice", "rollback", "api", 1200, "v0"))
  let report = chain.verify()
  assert_true(report.ok)
  assert_eq(report.checked, 2)
}

///|
test "audit chain reports first broken digest" {
  let event = AuditEvent::new("alice", "deploy", "api", 1000, "v1")
  let broken = AuditRecord::{
    index: 0,
    previous_digest: "genesis",
    event,
    digest: "changed",
  }
  let chain = AuditChain::{ name: "ops", genesis_digest: "genesis", records: [broken] }
  let report = chain.verify()
  assert_false(report.ok)
  assert_eq(report.broken_index, 0)
  assert_eq(report.reason, "digest_mismatch")
}

///|
test "chain proof captures length and head digest" {
  let chain = AuditChain::new("ops")
    .append(AuditEvent::new("alice", "deploy", "api", 1000, "v1"))
  let proof = chain.proof()
  assert_eq(proof.length, 1)
  assert_true(proof.matches(chain))
}

///|
test "json export keeps stable fields" {
  let chain = AuditChain::new("ops")
    .append(AuditEvent::new("alice", "deploy", "api", 1000, "v1"))
  assert_true(chain.records[0].to_json().contains("\"previous_digest\":\"genesis\""))
  assert_true(chain.verify().to_json().contains("\"ok\":true"))
  assert_true(chain.proof().to_json().contains("\"length\":1"))
}
