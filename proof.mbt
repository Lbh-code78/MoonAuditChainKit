///|
pub(all) struct ChainProof {
  chain_name : String
  length : Int
  head_digest : String
} derive(Eq, Debug)

///|
pub fn AuditChain::proof(self : AuditChain) -> ChainProof {
  { chain_name: self.name, length: self.length(), head_digest: self.head_digest() }
}

///|
pub fn ChainProof::matches(self : ChainProof, chain : AuditChain) -> Bool {
  self.chain_name == chain.name &&
  self.length == chain.length() &&
  self.head_digest == chain.head_digest()
}
