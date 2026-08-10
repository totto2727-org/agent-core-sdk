# Agent Core SDK

`agent-core-sdk` provides shared infrastructure for MoonBit SDKs that integrate with agent runtimes.

The `cli` package owns the native process lifecycle for JSONL-emitting agent CLIs: stdin delivery, ordered JSONL parsing and typed decoding, stderr capture, exit status reporting, callback-requested termination, and cancellation-safe child cleanup. Provider SDKs remain responsible for building invocations, defining provider-specific event types, and aggregating turns.

The `server` directory is reserved for future server-side infrastructure and intentionally contains no implementation.

## Targets

The `cli` package uses one source and package layout for the `native` and `wasm` targets. `native` remains the preferred target because the package launches agent CLI processes through the asynchronous process API. JavaScript, WebAssembly GC, and LLVM are not supported targets.

## Usage

```mbt check
struct Event {
  message : String
} derive(FromJson)

async fn example() -> @cli.RunResult {
  @cli.run(
    @cli.Invocation::new(
      command="agent",
      arguments=["run", "--format", "json"],
      input="Hello",
    ),
    async fn(event : Event) {
      println(event.message)
      true
    },
  )
}
```

Add the package to a consumer's `moon.pkg`:

```text
import {
  "totto2727/agent-core-sdk/cli",
}
```

## Development

Enter the Nix development shell and run the standard MoonBit checks:

```bash
nix develop
moon info
moon check
moon test
moon build
moon package --list
```

CI runs the same validation for each supported target: `moon check --target <target>`, `moon test --target <target>`, `moon build --target <target>`, and `moon package --list`.
