# agent-core-sdk

## Repository structure

```text
.github/workflows/  MoonBit CI and Mooncakes publication workflows
src/cli/             JSONL agent CLI process lifecycle package
src/server/          Reserved location for future server infrastructure
flake.nix            Reproducible MoonBit development shell
moon.mod             Module metadata and target policy
src/cli/README.mbt.md  Physical canonical end-user documentation
README.mbt.md          Relative symlink to src/cli/README.mbt.md
README.md              Relative symlink to README.mbt.md
```

## Development commands

### Execution rules

- Run commands from the repository root.
- Enter the pinned environment with `nix develop` before running MoonBit commands.
- Keep the physical canonical README at `src/cli/README.mbt.md` and preserve the root `README.md -> README.mbt.md -> src/cli/README.mbt.md` relative symlink chain.
- Validate the canonical README from the `src/cli` package because the module root has no `moon.pkg`.
- Do not create `CLAUDE.md`; `AGENTS.md` is the repository's developer and agent guidance.
- Read the `mbt-coding` and `mbt-test` skills before editing MoonBit production code or tests.

### Standard tasks

- `nix develop` — Enter the pinned MoonBit development environment.
- `moon info` — Regenerate package interface information after public API changes.
- `moon check` — Type-check the module using its preferred `wasm` target.
- `moon test` — Run the module's MoonBit tests using its preferred `wasm` target.
- `moon build` — Build the module using its preferred `wasm` target.
- `moon package --list` — Confirm the packages and files that will be published.
- `moon check README.mbt.md` — Check the root README symlink through MoonBit's literate Markdown entrypoint.
- `moon test README.mbt.md` — Test the root README symlink through the `cli` package context.

## Architecture

### CLI lifecycle

- `src/cli` owns invocation construction, stdin delivery, ordered JSONL parsing, typed event decoding, stderr capture, exit status reporting, callback-requested termination, and cancellation-safe child cleanup.
- `Invocation` contains the command, arguments, environment overrides, inheritance policy, and stdin input for one agent CLI process.
- `run` returns `Completed`, `Stopped`, or `Failed` and raises `AgentCliError` for malformed or mismatched JSONL events.
- Provider SDKs own provider-specific command arguments, event types, and turn aggregation.

### Target policy

- `wasm` is the preferred target and `native` remains supported as declared by `moon.mod`.
- JavaScript, WebAssembly GC, and LLVM are not declared targets for this module.
- The source and package layout is target-neutral; the process implementation comes from MoonBit's asynchronous process API.

### Reserved server boundary

- `src/server` is reserved for future server-side infrastructure and currently contains no implementation.
- Do not add provider-specific server behavior to `src/cli`.

## Development tools

- **MoonBit**: Type-checks, tests, builds, and packages the module.
- **Nix flakes**: Pin the MoonBit toolchain and provide reproducible local and CI environments.
- **GitHub Actions**: Run the shared MoonBit checks and publication workflow.
- **Mooncakes**: Hosts the published module and generated [`cli` API reference](https://mooncakes.io/docs/totto2727/agent-core-sdk/cli).

## Package-specific rules

- Keep public API documentation adjacent to its declaration with `///` comments so the Mooncakes API reference retains behavior and usage details.
- Keep user-facing examples in `README.mbt.md` as checked `mbt` blocks when they exercise the public contract.
- Preserve the `server` reservation and target declarations unless a separate API and target design is approved.

_This AGENTS.md was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [AGENTS template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/agents/template.md)._
