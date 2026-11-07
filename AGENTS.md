# AGENTS.md

## Start here

- Read `README.md`.
- Read `docs/README.md`.
- Search open Gitea issues before starting.

<!-- begin issue-workflow -->
## Issue tracker

The backlog is `docs/issues/`; native issues only track an item that has an open
pull request.

- Pick the highest-ranked task in `docs/issues/`.
- Open one native issue for that work item when the pull request starts.
- The pull request references the issue (`Part of #N` or `Closes #N`).
- Merging the pull request deletes the task file and closes the issue.
- A failed attempt appends to the task file and keeps it.
- Native issues created by the owner or external contributors stay native.
- One open pull request per repository and one issue per work item.
- Ranked native titles remain `3.x` bug, `2.x` documentation, `1.x` feature.
- Prefer the `gitea-api` helper for Gitea actions.
- When a pull request deletes files, add a `## Deletions` section.
- The bot may comment and open pull requests that reference an open issue; it
  does not create, edit, close, or relabel issues.
<!-- end issue-workflow -->

<!-- begin local-issues -->
## Local work records

- Agent work is tracked in `docs/issues/`, not in new native issues.
- Use `3.x` for bugs, `2.x` for documentation and chores, and `1.x` for
  features and code refactors. Higher fraction = more important.
- Filename: `<rank>-<slug>.json`; no trailing zero; one to six fractional digits.
- Exactly zero or one file may have `status: active`.
- Only the active file gets a native issue. Record `platform_issue_id` and
  `platform_issue_url` in it.
- A PR references the active file and closes the native issue:
  `Local-Issue: docs/issues/<file>.json` and `Closes #N`.
- On a failed PR, append an attempt locally, post the same summary on the native
  issue, close the PR, and keep the local file.
- On merge, delete the local file; the native issue closes through `Closes #N`.
- Native issues get one core label: `bug`, `documentation`, or `enhancement`.
  Keep security and area classification in local `tags`.
- Do not create extra native issues for agent work.
<!-- end local-issues -->

## Shared rules

- Follow the repository layout and build instructions in `README.md`.
- Use Git tags; do not publish release artifacts without an issue.
- Do not add editor or devcontainer configuration.

## Repository-specific rules

Add repository-specific behavior, constraints, and commands here.

## Package contract

### Identity

| Field | Value |
| --- | --- |
| Account | `gardusi-gustavo` |
| Registry | PyPI |
| Repository | `templates/py` |
| Package | `gardusi-gustavo-kit` |
| Import or consume | `from gardusi_gustavo_kit import ...` |
| Family | `gardusi-gustavo-kit` |
| Design type | Water |
| Repository contract | `infra/config/repo.json` |
| Version source | `VERSION` |

### Scope for 0.1.0

- **One capability.** Do not ship a general utility grab-bag.
- **Language strength:** crawling, ETL, and text or data plumbing.
- **0.1.0 ships:** async fetch, extract, normalize, and retry helpers.
- **Explicitly out of scope:** UI, a web framework, and data-science tooling.
- **Dependency rule:** near-zero dependencies; no framework or heavy runtime.

The design type is a mnemonic, not a contract.

### Install, import, and smoke test

```bash
pip install gardusi-gustavo-kit
```

```text
from gardusi_gustavo_kit import ...
```

Smoke test: create a virtual environment, pip install the wheel, and import the package.

The smoke test installs or imports the package cleanly and runs in under five
seconds after dependencies are available. It uses no database, external
service, or network mock.

### Development and release

- Semantic Versioning. `0.1.0` is the first public smoke-test release.
- `VERSION` is bare semver. The Git tag is `v0.1.0`. The registry version is
  `0.1.0`.
- `infra/config/repo.json` declares the publish target and CI profile.
- Releases are tag-driven.
- No credentials in code, manifests, or workflow files.
- Registry tokens come only from CI secrets.
- Run the repository's native build, lint, and tests before pushing.

```bash
PYTHONPATH=src python3 -m compileall -q src src/tests && PYTHONPATH=src python3 -m pytest -q src/tests
```

### Agent rules

- Do not add a web framework, ORM, UI framework, or heavy runtime.
- Do not add a dependency without a concrete use in `0.1.0`.
- Keep the public API small and documented.
- Do not change the package identifier without updating the reservation issue.
- Do not publish from a dirty tree.
- Record the published registry URL in issue `#23`.

### Links

- Practice hub: `#20`
- Automation hub: `#21`
- Onboarding issue: `#22`
- 0.1.0 issue: `#23`
- Reservation issue: `dashboards/ops#168`
- Identity decision: `dashboards/ops#192`
