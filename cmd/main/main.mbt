///|
fn main {
  let chain = @audit.AuditChain::new("deploy-audit")
    .append(@audit.AuditEvent::new("system", "deploy", "api", 1000, "v1"))
    .append(@audit.AuditEvent::new("operator", "approve", "api", 1100, "ok"))
  println("MoonAuditChainKit demo")
  println(chain.verify().to_json())
  println(chain.proof().to_json())
}
