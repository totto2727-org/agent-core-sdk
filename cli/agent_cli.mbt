///|
/// A complete invocation of a JSONL-emitting agent CLI.
pub struct Invocation {
  command : String
  arguments : Array[String]
  environment : Map[String, String]
  inherit_environment : Bool
  input : String
}

///|
/// Construct an agent CLI invocation.
pub fn Invocation::new(
  command~ : String,
  arguments~ : Array[String],
  input~ : String,
  environment? : Map[String, String] = Map([]),
  inherit_environment? : Bool = true,
) -> Invocation {
  { command, arguments, environment, inherit_environment, input }
}

///|
/// The process-level outcome of an agent CLI invocation.
pub(all) enum RunResult {
  Completed
  Stopped
  Failed(code~ : Int, stderr~ : String)
} derive(Debug, Eq)

///|
/// Errors raised while reading or decoding the JSONL protocol.
pub suberror AgentCliError {
  InvalidJson(line~ : String, cause~ : String)
} derive(Debug, Eq)
