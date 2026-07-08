///|
pub fn AuditEvent::to_json(self : AuditEvent) -> String {
  "{\"actor\":\"\{escape_json(self.actor)}\",\"action\":\"\{escape_json(self.action)}\",\"resource\":\"\{escape_json(self.resource)}\",\"timestamp_ms\":\{self.timestamp_ms},\"payload\":\"\{escape_json(self.payload)}\"}"
}

///|
pub fn AuditRecord::to_json(self : AuditRecord) -> String {
  "{\"index\":\{self.index},\"previous_digest\":\"\{escape_json(self.previous_digest)}\",\"digest\":\"\{escape_json(self.digest)}\",\"event\":\{self.event.to_json()}}"
}

///|
pub fn VerifyReport::to_json(self : VerifyReport) -> String {
  "{\"ok\":\{self.ok},\"checked\":\{self.checked},\"broken_index\":\{self.broken_index},\"reason\":\"\{escape_json(self.reason)}\"}"
}

///|
pub fn ChainProof::to_json(self : ChainProof) -> String {
  "{\"chain\":\"\{escape_json(self.chain_name)}\",\"length\":\{self.length},\"head_digest\":\"\{escape_json(self.head_digest)}\"}"
}

///|
fn escape_json(text : String) -> String {
  let buf = StringBuilder(size_hint=text.length() + 8)
  for i = 0; i < text.length(); i = i + 1 {
    let ch = text[i]
    if ch == '"' {
      buf.write_string("\\\"")
    } else if ch == '\\' {
      buf.write_string("\\\\")
    } else {
      buf.write_string(text[i:i + 1].to_owned())
    }
  }
  buf.to_string()
}
