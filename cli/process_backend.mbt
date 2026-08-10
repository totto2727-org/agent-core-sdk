///|
/// A target-independent process execution boundary for JSONL-emitting CLIs.
///
/// Target-specific packages construct this value from their process primitive.
/// The callback receives one output line at a time and returns whether execution
/// should continue.
pub struct ProcessBackend {
  priv execute : async (Invocation, async (String) -> Bool) -> RunResult
}

///|
/// Construct a process backend from a target-specific execution function.
pub fn ProcessBackend::new(
  execute : async (Invocation, async (String) -> Bool) -> RunResult,
) -> ProcessBackend {
  { execute, }
}

///|
/// Run an invocation through an injected backend and decode its JSONL events.
///
/// Returning `false` from `on_event` asks the backend to stop and return
/// `Stopped`. Malformed JSON or a typed event mismatch raises `InvalidJson`.
pub async fn[T : @json.FromJson] run_with_backend(
  invocation : Invocation,
  backend : ProcessBackend,
  on_event : async (T) -> Bool,
) -> RunResult {
  (backend.execute)(invocation, async fn(line : String) {
    let json = @json.parse(line) catch {
      error => raise AgentCliError::InvalidJson(line~, cause="\{error}")
    }
    let event : T = @json.from_json(json) catch {
      error => raise AgentCliError::InvalidJson(line~, cause="\{error}")
    }
    on_event(event)
  })
}
