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
