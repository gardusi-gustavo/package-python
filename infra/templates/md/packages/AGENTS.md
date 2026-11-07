# Repository Agent Guide: <Language> Package

Copy this section into the package repository's `AGENTS.md`, after the shared
guardrail blocks. Replace every `<...>` value. Keep the package contract short;
shared process rules belong in the generated toolkit blocks.

## Package identity

| Field | Value |
| --- | --- |
| Account | `gardusi-gustavo` |
| Registry | `<npm, PyPI, crates.io, NuGet, Go proxy, Maven Central, RubyGems, Packagist, Docker Hub>` |
| Repository | `templates/<name>` |
| Package identifier | `<exact registry name>` |
| Import path | `<exact import, using, require, or FROM path>` |
| Family | `gardusi-gustavo-kit` libraries; Docker uses `gardusi-gustavo/<role>` |
| Design type | `<Water, Electric, Steel, Normal, Fighting, Psychic, Fairy, Grass, Ditto>` |
| Repository contract | `infra/config/repo.json` |
| Version source | `VERSION` |

## Scope for 0.1.0

- **One capability.** Do not ship a general utility grab-bag.
- **Language strength:** `<why this language is the right tool>`
- **0.1.0 ships:** `<minimal API surface>`
- **Explicitly out of scope:** `<frameworks, ORMs, UI, crawling, etc.>`
- **Dependency rule:** near-zero dependencies; no framework or heavy runtime.

The design type is a mnemonic, not a contract:

- Python: Water, data and text plumbing.
- TypeScript: Electric, UI and browser state.
- Rust: Steel, deterministic and WebAssembly-friendly code.
- C#: Normal, desktop and Unity-adjacent .NET.
- Go: Fighting, CLI and service plumbing.
- Java: Psychic, JVM clients and tooling.
- Ruby: Fairy, text, Markdown, and task automation.
- PHP: Grass, request, HTML, and configuration helpers.
- Docker: Ditto, it becomes the runtime another repository needs.

## Install, import, and smoke test

```bash
<install command>
```

```text
<import snippet>
```

Smoke test:

```bash
<deterministic command>
```

The smoke test installs or imports the package cleanly and runs in under five
seconds after dependencies are available. It uses no database, external
service, or network mock.

## Development and release

- Semantic Versioning. `0.1.0` is the first public smoke-test release.
- `VERSION` is bare semver. The Git tag is `v0.1.0`. The registry version is
  `0.1.0`.
- `infra/config/repo.json` declares the publish target and CI profile.
- Releases are tag-driven.
- No credentials in code, manifests, or workflow files.
- Registry tokens come only from CI secrets.
- Run the repository's native build, lint, and tests before pushing.

## Agent rules

- Do not add a web framework, ORM, UI framework, or heavy runtime.
- Do not add a dependency without a concrete use in `0.1.0`.
- Keep the public API small and documented.
- Do not change the package identifier without updating the reservation issue.
- Do not publish from a dirty tree.
- Record the published registry URL in the repository's `1.98` issue.

## Links

- Practice hub: `#<n>`
- Automation hub: `#<n>`
- Onboarding issue: `#<n>`
- 0.1.0 issue: `#<n>`
- Reservation issue: `dashboards/ops#168`
