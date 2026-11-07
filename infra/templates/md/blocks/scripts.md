## Scripts

- `infra/scripts/ci/` is read-only. CI may execute it.
- `infra/scripts/manual/` writes files. CI must never execute it.
- A write helper is run manually while preparing a PR, not by CI.
- Validators accept `--root`, read only, and exit non-zero with the exact path.
- `ci.sh` calls `ci/all.sh`; `ci/all.sh` runs every `ci/validate-*.sh`.
- Do not add a write helper unless a manual step is genuinely required.
- Every write helper documents what it changes and how to check the diff.
- PRs contain the file changes; no bot commits and no auto-fixes.
- A manual workflow must be `workflow_dispatch` and must open a branch + PR,
  never push to `main`.
