# AGENTS.md

## Start here

- Read `README.md`.
- Read `docs/README.md`.
- Search open Gitea issues before starting.

<!-- begin issue-workflow -->
## Issue tracker

Gitea issues are the only active work tracker. `docs/issues/` is retired and
must not receive new records.

- Before starting, search this repository's open Gitea issues.
- Prefer an issue in the project board's `Ready` column. If no board exists,
  prefer a pinned issue. If none fits, create one.
- Labels: `bug`, `documentation`, `enhancement`. `question` is retired; triage
  a question into one of the three.
- Status lives on the Gitea project board, not in labels.
- Group work with milestones; do not add priority or area labels.
- Rank issues in the title with a type prefix: `3.x - Title` for bugs, `2.x`
  for documentation, `1.x` for features and ideas. Higher fraction = more
  important; reverse sort is the queue. Lower type runs after higher type.
- Ranks are decimal fractions, not versions: no trailing zeros (`3.1`, not
  `3.10`), no `0.x`, no `4.x`, up to 6 decimals, unique per repository.
- Minimal body requirements per type are in
  `ops/templates/docs/repository/issues.md`.
- `next-issue` selects the highest unblocked rank; do not use AI to pick the
  issue.
- Limits live in `ops/templates/docs/repository/limits.md`: 100 open issues,
  40 issue comments, 20 agent issue comments, 20 PR comments, 8 agent PR
  comments, 3 change-request rounds, 2 failed PRs per issue, and 10 merged
  slices per issue.
- A migration uses a chain of slice PRs. Non-final slices use `Part of #N`; the
  final slice uses `Closes #N`.
- A repo may keep one documented exception; see
  `ops/templates/docs/repository/labels.md`.
- Body sections:
  - required: Summary, Context, Expected outcome, Out of scope, Acceptance
    criteria, Plan, Decisions, Validation, References.
  - operations: Operational impact, Rollback, Problems encountered, Follow-ups,
    Definition of done.
- Use the operations sections when the change touches runtime, backups, secrets,
  data deletion, CI, or tags.
- No parent/child issue hierarchy. Link related issues with `#number`.
- Blocked work: name the blocker in a comment; `kapetao` moves the board
  column.
- `kapetim` may create issues and comment. It must not edit, close, reopen,
  relabel, assign, or delete an existing issue. Comment "ready to close" and
  hand off.
- `kapetim` may edit or delete files only inside a branch, and must call out
  deletions in the PR body. It must not force-push, delete remote branches or
  tags, approve, or merge.
- `kapetao` owns issue lifecycle, labels after creation, review, approval,
  merge, tags, repositories, tokens, and system changes.
- Prefer the `gitea-api` helper for Gitea actions; do not bypass it with raw
  `curl`.
- When a pull request deletes files, add a `## Deletions` section to the pull
  request body.
- Request review from `kapetao`; never merge.
- While a PR is open, add details or comments to the existing issue or PR. Do
  not open another PR or a new branch in that repository.
- If the PR exceeds the size budget, stop appending. File a follow-up issue for
  the remaining scope.
- If the PR is abandoned, comment with a restart note and ask `kapetao` to close
  it.
- Branch and PR: reference the issue (`Closes #N`); record decisions in the
  issue; `kapetao` closes it when the PR merges.
- Issues inherit repository visibility. Never put credentials, tokens, private
  data, or unredacted logs in an issue.
<!-- end issue-workflow -->

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
| Account | `kapetim` |
| Registry | PyPI |
| Repository | `packages/python-pypi` |
| Package | `kapetim-kit` |
| Import or consume | `from kapetim_kit import ...` |
| Family | `kapetim-kit` |
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
pip install kapetim-kit
```

```text
from kapetim_kit import ...
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
