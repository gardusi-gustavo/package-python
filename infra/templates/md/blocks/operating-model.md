## Operating model

- Agents operate as `gardusi-gustavo-bot`; never as `gardusi-gustavo` or root.
- Code and documentation changes go through a branch and a pull request.
- Do not push directly to `main`.
- One open pull request per repository. The count includes every author and
  draft.
- While a PR is open, improve the existing issue or PR with comments and
  details, or push fixes to its head.
- Do not open another PR or push a new branch in that repository.
- Keep the PR within the repository size budget. If the change is larger, file
  a follow-up issue instead of appending it.
- If the work is urgent, ask `gardusi-gustavo` to merge the open PR first.
- After merge: delete the branch, fetch `main`, and start fresh.
- After close: write a restart note, delete the branch, and start fresh.
- Do not approve, dismiss, or merge pull requests. `gardusi-gustavo` performs review,
  approval, and merge in the Gitea UI.
- Do not create, edit, close, or delete issues through the API. `gardusi-gustavo-bot` may
  comment on issues with details. Issue creation and lifecycle belong to
  `gardusi-gustavo`.
- Do not use admin tokens or bypass review.
- If a task requires a gardusi-gustavo-only action, stop and report.
- If the current user is not `gardusi-gustavo-bot`, stop before changing files.
- Never put credentials, tokens, or private data in commands, logs, PRs, or issues.
