# Repository self-containment

**What this is:** the checklist for making this repository understandable,
recoverable, and copyable without Gitea.

## Source of truth

- Repository: `templates/md`
- Visibility: public
- Owner: `human`
- Git platform: Gitea
- Local checkout: `~/repos/templates/md`

## Durable data

- [x] `README.md` and `AGENTS.md`
- [x] `docs/README.md`
- [x] `docs/issues/` schema, template, and backlog
- [x] decisions and operating rules in AGENTS
- [x] repository scaffold
- [x] workflow templates
- [x] `VERSION`
- [ ] `CHANGELOG.md`
- [x] release tags
- [ ] `infra/config/repo.json`
- [ ] CI workflow
- [ ] tests
- [x] external service references
- [x] backup and restore notes

## External-only data

- issues and comments: Gitea owner issues
- PR discussions: Gitea
- attachments and media: none
- secrets: none
- package registry artifacts: none
- external services: Gitea only

## Migration status

- [x] Agent-created issues migrated: none open
- [ ] Owner-created issues classified
- [ ] Closed history exported to backup
- [x] Wiki content not applicable
- [x] GitHub v1 issue created: #15

## Copy test

1. Clone the repository.
2. Read the template guide.
3. Render a repository scaffold.
4. Validate a local issue file.
