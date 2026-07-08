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
