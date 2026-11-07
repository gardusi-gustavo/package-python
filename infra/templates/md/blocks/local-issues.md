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
