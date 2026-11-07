# Contract behavior

`infra/config/repo.json` is more than identity. Three fields change how the
toolkit behaves.

## Publish targets

```json
"publish": ["npm"]
```

| Target | Required manifest |
| --- | --- |
| `npm` | `package.json` |
| `pypi` | `pyproject.toml` |
| `crates` | `Cargo.toml` |
| `docker` | at least one `infra/docker/*.dockerfile` |
| `nuget` | a `*.csproj` |
| `go` | `go.mod` |
| `maven` | `pom.xml` |
| `gem` | a `*.gemspec` |
| `composer` | `composer.json` |

`validate-publish-targets.sh` is called by `validate-repo.sh` and by
`release.sh`. An unknown target fails closed.

## Hubs

```json
"hubs": {
  "practice": 21,
  "automation": 22
}
```

`render-hubs.sh` prints the two Markdown links:

```bash
./infra/scripts/render-hubs.sh --root .
```

The future `sync-agents.sh` will insert these into the identity block when the
template tooling moves into this repository.

## CI profile

```json
"ci": {
  "profile": "python"
}
```

`render-ci-profile.sh` prints the runner label:

```bash
./infra/scripts/render-ci-profile.sh --root .
# ci-python
```

The default is `ci-universal`. `sb deps install` renders the workflow
`runs-on` value from this label.

## Dependencies

`repo.json` declares only the template repositories this repository consumes:

```json
"dependencies": {
  "templates/yml": "v1.0.1",
  "templates/json": "v0.2.1"
}
```

Pins are exact tags. `sb deps install` installs them; `sb deps check` verifies
them. There is no global lock file.

## Commands

```bash
./infra/scripts/ci/validate-publish-targets.sh --root .
./infra/scripts/render-ci-profile.sh --root .
./infra/scripts/render-hubs.sh --root .
```
