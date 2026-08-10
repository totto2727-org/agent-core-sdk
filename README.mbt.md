# Agent Core SDK

`agent-core-sdk` provides shared infrastructure for MoonBit SDKs that integrate with agent runtimes.

The `cli` package owns the target-independent invocation, JSONL decoding, callback, result, and error contracts for agent CLIs. Provider SDKs remain responsible for building invocations, defining provider-specific event types, and aggregating turns.

The `cli/native` package supplies the concrete local-process backend: stdin delivery, stdout streaming, stderr capture, exit status reporting, callback-requested termination, and cancellation-safe child cleanup. It is intentionally declared for the `native` target only. The contract package and its fixture support `native` and `js`; the JavaScript target does not claim local CLI process execution.

The `server` directory is reserved for future server-side infrastructure and intentionally contains no implementation.

## Usage

```mbt check
struct Event {
  message : String
} derive(FromJson)

async fn example() -> @cli.RunResult {
  @cli.run_with_backend(
    @cli.Invocation::new(
      command="agent",
      arguments=["run", "--format", "json"],
      input="Hello",
    ),
    @native.backend(),
    fn(event : Event) {
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
  "totto2727/agent-core-sdk/cli/native",
}
```

Consumers that provide another process implementation depend only on `cli` and construct a `ProcessBackend` with `ProcessBackend::new`. See `examples/contract` for an executable target-independent fixture.

## Target support

| Package | Supported targets | Local process execution |
| --- | --- | --- |
| `totto2727/agent-core-sdk/cli` | `native`, `js` | No; contract and JSONL lifecycle only |
| `totto2727/agent-core-sdk/cli/native` | `native` | Yes |
| `totto2727/agent-core-sdk/examples/contract` | `native`, `js` | No; deterministic contract fixture |

Target support is verified package by package. `--target all` is not used as a completion claim.

## Development

Enter the Nix development shell and run the standard MoonBit checks:

```bash
nix develop
moon info
moon check --target native
moon check --target js cli
moon test --target native
moon test --target js cli
moon build --target native
moon run --target js examples/contract
moon package --list
```
