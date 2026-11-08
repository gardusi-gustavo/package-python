## Operating model

- Agents operate as `bot-event`; never as `human` or root.
- Code and documentation changes go through a branch and a pull request.
- Do not push directly to `main`.
- One open pull request per repository. The count includes every author and
  draft.
- While a PR is open, improve the existing issue or PR with comments and
  details, or push fixes to its head.
- Do not open another PR or push a new branch in that repository.
- Keep the PR within the repository size budget. If the change is larger, file
  a follow-up issue instead of appending it.
- If the work is urgent, ask `human` to merge the open PR first.
- After merge: delete the branch, fetch `main`, and start fresh.
- After close: write a restart note, delete the branch, and start fresh.
- Do not approve, dismiss, or merge pull requests. `human` performs review,
  approval, and merge in the Gitea UI.
- Do not create, edit, close, or delete issues through the API. `bot-event` may
  comment on issues with details. Issue creation and lifecycle belong to
  `human`.
- Do not use admin tokens or bypass review.
- If a task requires a human-only action, stop and report.
- If the current user is not `bot-event`, stop before changing files.
- Never put credentials, tokens, or private data in commands, logs, PRs, or issues.
