///|
pub(all) struct AuditChain {
  name : String
  genesis_digest : String
  records : Array[AuditRecord]
} derive(Eq, Debug)

///|
pub fn AuditChain::new(name : String) -> AuditChain {
  { name, genesis_digest: "genesis", records: [] }
}

///|
pub fn AuditChain::append(
  self : AuditChain,
  event : AuditEvent,
) -> AuditChain {
  let output : Array[AuditRecord] = []
  for record in self.records {
    output.push(record)
  }
  let previous = if output.length() == 0 {
    self.genesis_digest
  } else {
    output[output.length() - 1].digest
  }
  output.push(AuditRecord::new(output.length(), previous, event))
  { name: self.name, genesis_digest: self.genesis_digest, records: output }
}

///|
pub fn AuditChain::length(self : AuditChain) -> Int {
  self.records.length()
}

///|
pub fn AuditChain::head_digest(self : AuditChain) -> String {
  if self.records.length() == 0 {
    self.genesis_digest
  } else {
    self.records[self.records.length() - 1].digest
  }
}
