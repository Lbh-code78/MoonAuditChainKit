///|
pub(all) struct AuditEvent {
  actor : String
  action : String
  resource : String
  timestamp_ms : Int
  payload : String
} derive(Eq, Debug)

///|
pub fn AuditEvent::new(
  actor : String,
  action : String,
  resource : String,
  timestamp_ms : Int,
  payload : String,
) -> AuditEvent {
  { actor, action, resource, timestamp_ms, payload }
}

///|
pub fn AuditEvent::canonical(self : AuditEvent) -> String {
  "\{self.actor}|\{self.action}|\{self.resource}|\{self.timestamp_ms}|\{self.payload}"
}

///|
pub fn digest_text(text : String) -> String {
  let mut hash = 16777619
  for i = 0; i < text.length(); i = i + 1 {
    hash = (hash ^ text[i].to_int()) * 131
    if hash < 0 {
      hash = 0 - hash
    }
  }
  "h\{hash}"
}
