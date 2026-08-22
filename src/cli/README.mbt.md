# Agent Core SDK CLI

The `totto2727/agent-core-sdk/cli` package owns target-neutral process execution for JSONL-emitting agent CLIs.

Consumer prerequisites, installation, imports, and the common `run` flow are documented in the root [Setup](../../README.mbt.md#setup) and [Usage](../../README.mbt.md#usage).

## Package role

- `Invocation` carries the command, arguments, environment overrides, inheritance policy, and stdin for one child process.
- `run` decodes each JSONL line into the caller's `FromJson` type and invokes the callback in stdout order.
- The callback returns `true` to continue or `false` to terminate the child and receive `Stopped`.
- `RunResult` reports `Completed`, callback-requested `Stopped`, or `Failed(code~, stderr~)` for a nonzero exit.
- Malformed JSONL and incompatible events raise `AgentCliError::InvalidJson` after child resources are cleaned up.
- Provider SDKs remain responsible for provider-specific arguments, event types, and turn aggregation.

## Runnable examples

See the [checked invocation flows](./agent_cli_test.mbt) for completion, callback stop, failed exits, invalid JSONL, environment handling, and cleanup behavior.

## API

[Mooncakes API reference for `totto2727/agent-core-sdk/cli`](https://mooncakes.io/docs/totto2727/agent-core-sdk/cli)
