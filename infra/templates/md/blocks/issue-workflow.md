## Issue tracker

Gitea issues are the only active work tracker. `docs/issues/` is retired and
must not receive new records.

- Before starting, search this repository's open Gitea issues.
- Capture evidence before opening an issue: `docs/repository/problem-intake.md`.
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
  `infrastructure/templates/docs/repository/issues.md`.
- `next-issue` selects the highest unblocked rank; do not use AI to pick the
  issue.
- Limits live in `infrastructure/templates/docs/repository/limits.md`: 100 open issues,
  40 issue comments, 20 agent issue comments, 20 PR comments, 8 agent PR
  comments, 3 change-request rounds, 2 failed PRs per issue, and 10 merged
  slices per issue.
- A migration uses a chain of slice PRs. Non-final slices use `Part of #N`; the
  final slice uses `Closes #N`.
- A repo may keep one documented exception; see
  `infrastructure/templates/docs/repository/labels.md`.
- Body sections:
  - required: Summary, Context, Expected outcome, Out of scope, Acceptance
    criteria, Plan, Decisions, Validation, References.
  - operations: Operational impact, Rollback, Problems encountered, Follow-ups,
    Definition of done.
- Use the operations sections when the change touches runtime, backups, secrets,
  data deletion, CI, or tags.
- No parent/child issue hierarchy. Link related issues with `#number`.
- Blocked work: name the blocker in a comment; `gardusi-gustavo` moves the board
  column.
- `gardusi-gustavo-bot` may comment on issues and open pull requests that reference at
  least one open issue. It must not create, edit, close, reopen, relabel,
  assign, or delete an issue. Comment details and "ready to close"; hand off.
- `gardusi-gustavo-bot` may edit or delete files only inside a branch, and must call out
  deletions in the PR body. It must not force-push, delete remote branches or
  tags, approve, or merge.
- `gardusi-gustavo` creates issues and owns lifecycle, labels, review, approval,
  merge, tags, repositories, tokens, and system changes.
- Prefer the `gitea-api` helper for Gitea actions; do not bypass it with raw
  `curl`.
- When a pull request deletes files, add a `## Deletions` section to the pull
  request body.
- Request review from `gardusi-gustavo`; never merge.
- While a PR is open, add details or comments to the existing issue or PR. Do
  not open another PR or a new branch in that repository.
- Merge the oldest open PR first; a newer PR must not merge while an older one
  is open.
- If the PR exceeds the size budget, stop appending. File a follow-up issue for
  the remaining scope.
- If the PR is abandoned, comment with a restart note and ask `gardusi-gustavo` to close
  it.
- Branch and PR: reference the issue (`Closes #N`); record decisions in the
  issue; `gardusi-gustavo` closes it when the PR merges.
- Issues inherit repository visibility. Never put credentials, tokens, private
  data, or unredacted logs in an issue.
