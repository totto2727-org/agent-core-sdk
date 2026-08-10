///|
struct Event {
  sequence : Int
} derive(FromJson)

///|
async fn main {
  let commands : Array[String] = []
  let backend = @cli.ProcessBackend::new(async fn(invocation, on_line) {
    commands.push(invocation.command)
    for line in ["{\"sequence\":1}", "{\"sequence\":2}"] {
      if !on_line(line) {
        return @cli.RunResult::Stopped
      }
    }
    @cli.RunResult::Completed
  })
  let sequences : Array[Int] = []
  let result = @cli.run_with_backend(
    @cli.Invocation::new(command="fixture", arguments=[], input="request"),
    backend,
    fn(event : Event) {
      sequences.push(event.sequence)
      true
    },
  )
  let result_text = match result {
    Completed => "Completed"
    Stopped => "Stopped"
    Failed(code~, stderr~) => "Failed(\{code.to_string()},\{stderr})"
  }
  let sequence_text = sequences
    .map(fn(sequence) { sequence.to_string() })
    .join(",")
  println("\{result_text}:\{sequence_text}:\{commands.join(",")}")
}
