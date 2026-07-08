///|
pub(all) struct VerifyReport {
  ok : Bool
  checked : Int
  broken_index : Int
  reason : String
} derive(Eq, Debug)

///|
pub fn AuditChain::verify(self : AuditChain) -> VerifyReport {
  let mut previous = self.genesis_digest
  for index = 0; index < self.records.length(); index = index + 1 {
    let record = self.records[index]
    if record.index != index {
      return {
        ok: false,
        checked: index,
        broken_index: index,
        reason: "index_mismatch",
      }
    }
    if record.previous_digest != previous {
      return {
        ok: false,
        checked: index,
        broken_index: index,
        reason: "previous_digest_mismatch",
      }
    }
    if !record.valid() {
      return {
        ok: false,
        checked: index,
        broken_index: index,
        reason: "digest_mismatch",
      }
    }
    previous = record.digest
  }
  { ok: true, checked: self.records.length(), broken_index: -1, reason: "ok" }
}

///|
pub fn AuditChain::valid(self : AuditChain) -> Bool {
  self.verify().ok
}
