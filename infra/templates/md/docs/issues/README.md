# Local issues

**What this is:** the agent work record stored inside the repository.

Local issues are the durable, zip-friendly source of agent work. Native Gitea or
GitHub issues are a visibility mirror for the one active item.

## Rank

Higher fraction = more important.

| Rank | Type | Native label |
| --- | --- | --- |
| `3.x` | Bug, security issue | `bug` |
| `2.x` | Documentation, chore, metadata | `documentation` |
| `1.x` | Feature, enhancement, code refactor | `enhancement` |

Docs outrank features because they are quick to review and low risk.

Examples:

```text
3.9-fix-auth-token.json
3.1-fix-table-overflow.json
2.5-update-readme.json
1.9-add-json-exporter.json
1.1-add-cli-flag.json
```

## Filename

```text
<rank>-<slug>.json
```

Rules:

- rank is `1`, `2`, or `3`, followed by `.` and one to six digits
- no trailing zero: `3.1`, not `3.10`
- slug is lowercase letters, digits, and hyphens
- filename rank must match the JSON `id` and `rank`
- rank must be unique in the repository

## Status

- `backlog` — not active, no native issue
- `active` — current work item, exactly zero or one, must have a native issue
- `blocked` — waiting on another item, no native issue

## Lifecycle

1. Create a local file with `status: backlog`.
2. Promote it to `active`.
3. Create the native issue with title `<rank> - <title>`.
4. Record `platform`, `platform_issue_id`, and `platform_issue_url`.
5. Open one PR with:

```text
Local-Issue: docs/issues/<file>.json
Closes #<native issue>
```

6. If the PR fails:

   - append an attempt to `attempts`
   - post the same summary as a native issue comment
   - close the PR
   - keep the local file for the next attempt

7. If the PR merges:

   - delete the local file in that PR
   - the native issue closes through `Closes #`

## Limits

- file: 300 lines maximum
- `limits.max_commits`: maximum commits in the PR branch
- `limits.max_file_changes`: maximum changed files

## Labels

Native issues get exactly one core label: `bug`, `documentation`, or
`enhancement`. Keep `security`, `area/*`, and other local classification in
`tags`.

External or owner-created native issues are not converted unless the owner asks.

## Legacy migration fields

Migrated platform issues may include a `legacy` object with the original issue ID, URL, author, labels, comments count, original rank/title, and body.
