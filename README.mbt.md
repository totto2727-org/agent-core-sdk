# Agent Core SDK

`totto2727/agent-core-sdk` is a MoonBit module that provides shared process infrastructure for SDKs invoking agent runtimes through JSONL.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

Add the module to a MoonBit project and import the package that owns the agent CLI process lifecycle:

```bash
moon add totto2727/agent-core-sdk@0.1.1
```

```mbt check
///|
struct Event {
  message : String
} derive(FromJson)

///|
async test "invoke the shared CLI package" {
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

Declare `totto2727/agent-core-sdk/cli` in the consumer package's `moon.pkg` and see the [CLI package guide](src/cli/README.mbt.md) for the complete invocation contract.

## Key features

- Provides one target-neutral `cli` package for invoking JSONL-emitting agent CLIs.
- Supports the `wasm` preferred target and the `native` target declared by the module.
- Keeps provider-specific command construction, event models, and turn aggregation in provider SDKs.
- Publishes a generated [Mooncakes API reference](https://mooncakes.io/docs/totto2727/agent-core-sdk/cli) for the public package API.

## Prerequisites

- **MoonBit**: Install the MoonBit toolchain and `moon` command.
- **Agent CLI**: Make the executable used by `cli.Invocation` available to the consumer process.

## Setup

1. Add the module to a MoonBit project.

```bash
moon add totto2727/agent-core-sdk@0.1.1
```

2. Import `totto2727/agent-core-sdk/cli` from the package that invokes the agent CLI.

## API

[Mooncakes `totto2727/agent-core-sdk/cli` API reference](https://mooncakes.io/docs/totto2727/agent-core-sdk/cli)

## Development

See [AGENTS.md](./AGENTS.md) for repository structure, package ownership, and development commands.

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
