# Agent Core SDK

`agent-core-sdk` provides shared MoonBit infrastructure for SDKs that invoke agent runtimes through JSONL.

This document provides the canonical `README.mbt.md` content; maintain `README.mbt.md -> src/cli/README.mbt.md` and `README.md -> README.mbt.md` as relative symlinks.

## Usage

Install the published module and import its CLI package:

```bash
moon add totto2727/agent-core-sdk@0.1.1
```

```mbt check
///|
struct Event {
  message : String
} derive(FromJson)

///|
async test "run streams a JSONL event" {
  let received : Array[String] = []
  let result = @cli.run(
    @cli.Invocation::new(
      command="/usr/bin/printf",
      arguments=["{\"message\":\"Hello\"}\\n"],
      input="",
    ),
    fn(event : Event) {
      received.push(event.message)
      true
    },
  )
  debug_inspect(result, content="Completed")
  assert_eq(received, ["Hello"])
}
```

Declare the package in a consumer's `moon.pkg`:

```text
import {
  "totto2727/agent-core-sdk/cli",
}
```

## Key features

- Streams ordered JSONL events and decodes them into a caller-provided `FromJson` type.
- Captures stdin, stderr, exit status, callback-requested termination, and cancellation-safe child cleanup in one result contract.
- Supports the `wasm` preferred target and the `native` target with one target-neutral package layout.
- Leaves provider-specific command construction, event models, and turn aggregation to provider SDKs.

## Prerequisites

- **MoonBit**: Install the MoonBit toolchain and `moon` command.
- **Agent CLI**: Make the executable named by `Invocation.command` available to the process environment.

## Setup

1. Add the module to a MoonBit project.

```bash
moon add totto2727/agent-core-sdk@0.1.1
```

2. Import `totto2727/agent-core-sdk/cli` from the package that invokes the agent CLI.

## API

[Mooncakes `totto2727/agent-core-sdk/cli` API reference](https://mooncakes.io/docs/totto2727/agent-core-sdk/cli)

## Development

See [AGENTS.md](../../AGENTS.md) for repository structure, target policy, and development commands.

## License

[MIT](../../LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
