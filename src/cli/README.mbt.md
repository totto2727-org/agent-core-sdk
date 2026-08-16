# Agent Core SDK CLI

The `totto2727/agent-core-sdk/cli` package runs an agent CLI as a child process, writes its stdin, decodes ordered JSONL events, captures failed-exit stderr, and reports the process outcome.

This document is canonical `src/cli/README.mbt.md`.

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
  let result = @cli.run(
    @cli.Invocation::new(
      command="/usr/bin/printf",
      arguments=["{\"message\":\"Hello\"}\\n"],
      input="",
    ),
    fn(event : Event) {
      assert_eq(event.message, "Hello")
      true
    },
  )
  debug_inspect(result, content="Completed")
}
```

The callback receives events in stdout order. Return `true` to continue streaming or `false` to terminate the child and receive `Stopped`.

Declare the package in a consumer's `moon.pkg`:

```text
import {
  "totto2727/agent-core-sdk/cli",
}
```

## Key features

- `Invocation` carries the command, arguments, environment overrides, inheritance policy, and stdin for one child process.
- `run` decodes each JSONL line into the caller's `FromJson` type and invokes the callback once per event.
- `RunResult` reports `Completed`, callback-requested `Stopped`, or `Failed(code~, stderr~)` for a nonzero exit.
- Malformed JSONL and events that do not match the requested type raise `AgentCliError::InvalidJson` after child resources are cleaned up.
- Provider SDKs remain responsible for provider-specific command arguments, event types, and turn aggregation.

## Prerequisites

- **MoonBit**: Install the MoonBit toolchain and `moon` command.
- **Agent CLI**: Make the executable named by `Invocation.command` available to the process environment.

## Setup

1. Add the module to a MoonBit project.

```bash
moon add totto2727/agent-core-sdk@0.1.1
```

2. Import `totto2727/agent-core-sdk/cli` from the package that invokes the agent CLI.

3. Construct an `Invocation` with the child command and input, then await `run` with an event decoder and callback.

## API

[Mooncakes `totto2727/agent-core-sdk/cli` API reference](https://mooncakes.io/docs/totto2727/agent-core-sdk/cli)

## Development

See [AGENTS.md](../../AGENTS.md) for repository structure, package ownership, target policy, and development commands.

## License

[MIT](../../LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
