# Agent Core SDK

`totto2727/agent-core-sdk` is a MoonBit module that provides shared process infrastructure for SDKs invoking agent runtimes through JSONL.

## Usage

Run a JSONL-emitting command, observe the decoded event, and inspect its completion status:

```moonbit
///|
async fn run_once() -> @cli.RunResult {
  let result = @cli.run(
    @cli.Invocation::new(
      command="/usr/bin/printf",
      arguments=["\"Hello\"\\n"],
      input="",
    ),
    fn(message : String) raise {
      assert_eq(message, "Hello")
      true
    },
  )
  debug_inspect(result, content="Completed")
  result
}
```

See the [CLI package guide](src/cli/README.mbt.md) for its owned invocation contract, generated API, and direct checked-flow link.

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
moon add totto2727/agent-core-sdk@0.1.2
```

2. Import `totto2727/agent-core-sdk/cli` from the package that invokes the agent CLI.

```text
import {
  "totto2727/agent-core-sdk/cli" @cli,
}
```

## API

[Mooncakes `totto2727/agent-core-sdk/cli` API reference](https://mooncakes.io/docs/totto2727/agent-core-sdk/cli)

## Development

See [AGENTS.md](./AGENTS.md) for repository structure, package ownership, and development commands.

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
