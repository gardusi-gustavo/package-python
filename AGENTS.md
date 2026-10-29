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
- Prefer a `status:ready` issue. If none fits, create an issue first.
- Labels:
  - `type:initiative|investigation|enhancement|bug|task|question`
  - `status:idea|backlog|ready|in-progress|blocked|done|dropped`
  - `priority:low|normal|high|critical`
  - `area:<area>`
- Body sections: Summary, Context, Expected outcome, Out of scope, Acceptance
  criteria, Plan, Decisions, Validation, References.
- No parent/child issue hierarchy. Link related issues with `#number`.
- Blocked work: set `status:blocked` and name the blocker in the issue.
- Branch and PR: reference the issue (`Closes #N`); record decisions in the
  issue; close it when the PR merges.
- Issues inherit repository visibility. Never put credentials, tokens, private
  data, or unredacted logs in an issue.
<!-- end issue-workflow -->

## Shared rules

- Follow the repository layout and build instructions in `README.md`.
- Use Git tags; do not publish release artifacts without an issue.
- Do not add editor or devcontainer configuration.

## Repository-specific rules

Add repository-specific behavior, constraints, and commands here.
