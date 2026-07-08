///|
pub(all) struct AuditRecord {
  index : Int
  previous_digest : String
  event : AuditEvent
  digest : String
} derive(Eq, Debug)

///|
pub fn AuditRecord::new(
  index : Int,
  previous_digest : String,
  event : AuditEvent,
) -> AuditRecord {
  let safe_index = if index >= 0 { index } else { 0 }
  let body = "\{safe_index}|\{previous_digest}|\{event.canonical()}"
  { index: safe_index, previous_digest, event, digest: digest_text(body) }
}

///|
pub fn AuditRecord::recompute_digest(self : AuditRecord) -> String {
  digest_text("\{self.index}|\{self.previous_digest}|\{self.event.canonical()}")
}

///|
pub fn AuditRecord::valid(self : AuditRecord) -> Bool {
  self.digest == self.recompute_digest()
}
