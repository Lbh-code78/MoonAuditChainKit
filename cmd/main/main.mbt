///|
fn main {
  let event = @audit.AuditEvent::new("system", "deploy", "api", 1000, "v1")
  println("MoonAuditChainKit demo")
  println(event.canonical())
  println(@audit.digest_text(event.canonical()))
}
