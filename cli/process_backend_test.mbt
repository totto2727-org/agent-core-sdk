///|
priv struct ContractEvent {
  sequence : Int
} derive(FromJson)

///|
fn contract_backend(
  lines : Array[String],
  result : RunResult,
  invocations : Array[Invocation],
) -> ProcessBackend {
  ProcessBackend::new(async fn(invocation, on_line) {
    invocations.push(invocation)
    for line in lines {
      if !on_line(line) {
        return Stopped
      }
    }
    result
  })
}

///|
async test "run_with_backend decodes ordered events through the contract" {
  let invocations : Array[Invocation] = []
  let backend = contract_backend(
    ["{\"sequence\":1}", "{\"sequence\":2}"],
    Completed,
    invocations,
  )
  let received : Array[Int] = []
  let result = run_with_backend(
    Invocation::new(
      command="fixture",
      arguments=["run", "--json"],
      input="request",
      environment={ "CONTRACT": "value" },
      inherit_environment=false,
    ),
    backend,
    fn(event : ContractEvent) {
      received.push(event.sequence)
      true
    },
  )
  debug_inspect(result, content="Completed")
  debug_inspect(received, content="[1, 2]")
  inspect(invocations[0].command, content="fixture")
  debug_inspect(invocations[0].arguments, content="[\"run\", \"--json\"]")
  inspect(invocations[0].input, content="request")
  inspect(invocations[0].environment["CONTRACT"], content="value")
  assert_false(invocations[0].inherit_environment)
}

///|
async test "run_with_backend rejects malformed JSON from the contract" {
  let backend = contract_backend(["{not-json"], Completed, [])
  let message = try {
    run_with_backend(
      Invocation::new(command="fixture", arguments=[], input="request"),
      backend,
      fn(_ : Json) { true },
    )
    |> ignore
    "no error"
  } catch {
    AgentCliError::InvalidJson(line~, cause~) => "\{line}:\{cause}"
    error => "unexpected: \{error}"
  }
  assert_true(message.has_prefix("{not-json:"))
}

///|
async test "run_with_backend stops when the event callback returns false" {
  let backend = contract_backend(
    ["{\"sequence\":1}", "{\"sequence\":2}"],
    Completed,
    [],
  )
  let received : Array[Int] = []
  let result = run_with_backend(
    Invocation::new(command="fixture", arguments=[], input="request"),
    backend,
    fn(event : ContractEvent) {
      received.push(event.sequence)
      false
    },
  )
  debug_inspect(result, content="Stopped")
  debug_inspect(received, content="[1]")
}
