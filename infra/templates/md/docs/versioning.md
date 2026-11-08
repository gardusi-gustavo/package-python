# Versioning

One version per repository. `VERSION` is the source of truth.

## Format

`VERSION` contains bare semver:

```text
1.4.0
```

Rules:

- no `v` prefix
- no quotes
- no language prefix
- one trailing newline
- stable `MAJOR.MINOR.PATCH` for now

## Adapters

The release tooling adds the target-specific form. Do not store it twice.

| Target | Derived from `1.4.0` |
| --- | --- |
| Git tag | `v1.4.0` |
| Gitea release | `v1.4.0` |
| Docker image | `1.4.0`, `base-1.4.0`, `universal-1.4.0` |
| npm | `1.4.0` in `package.json` |
| PyPI | `1.4.0` in `pyproject.toml` |
| crates.io | `1.4.0` in `Cargo.toml` |
| Go module | `v1.4.0` tag |

`VERSION` is canonical. Language manifests must agree with it. CI enforces the
agreement with `infra/scripts/check-version.sh`.

## Commands

```bash
./infra/scripts/check-version.sh --root .
./infra/scripts/check-version.sh --root . --release
./infra/scripts/release.sh
```

`release.sh` reads `VERSION`, requires a clean `main`, verifies the manifests,
creates `v$(cat VERSION)`, and pushes the tag. It must run as `user` (Gitea `human`) because
`v*` tags are protected.

Bump `VERSION` in a reviewed pull request before running the release. The tag
is the publication step, not the version edit.

## Bump rules

| Change | Bump |
| --- | --- |
| breaking consumer contract | major |
| backward-compatible feature or template addition | minor |
| fix, docs, CI, internal change | patch |

## Template repositories

Every template repo under `templates/` is an independent package. It has its own
`VERSION` and its own tags. There is no organization-wide lock file.

A consumer pins only what it uses in `infra/config/repo.json`:

```json
{
  "dependencies": {
    "templates/yml": "v1.0.1",
    "templates/json": "v0.2.1",
    "templates/sh": "v0.4.2"
  }
}
```

- Pins are exact `vX.Y.Z` tags.
- `sb deps install` fetches each dependency's `dist/manifest.json` and verifies
  every file checksum.
- `sb deps check` fails on drift in CI.
- `sb deps update templates/yml` is the only way to move a pin.
- Updating one template repo never forces an update on another.

## Non-publishing repositories

Every repository still gets `VERSION`. If the repository does not publish a
package, the version is used for tags, releases, and rollback points.

## Pre-releases

Keep stable `X.Y.Z` for now. If a pre-release is needed later, use
`X.Y.Z-rc.1` in `VERSION` and let the adapter convert it for the target
(for example, PyPI uses `X.Y.Zrc1`).
