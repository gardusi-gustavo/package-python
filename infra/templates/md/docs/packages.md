# Package repositories

**What this is:** the shared contract for repositories under the `templates`
organization.

## Identity

- Account: `gardusi-gustavo` on every registry.
- Library family: `gardusi-gustavo-kit`.
- Docker images: `gardusi-gustavo/<role>`.
- Repository contract: `infra/config/repo.json`.

| Repository | Registry | Package | Import or consume |
| --- | --- | --- | --- |
| `ts` | npm | `@gardusi-gustavo/kit` | `import { ... } from "@gardusi-gustavo/kit"` |
| `py` | PyPI | `gardusi-gustavo-kit` | `from gardusi_gustavo_kit import ...` |
| `rs` | crates.io | `gardusi-gustavo-kit` | `use gardusi_gustavo_kit::...` |
| `cs` | NuGet | `Gardusi.Gustavo.Kit` | `using Gardusi.Gustavo.Kit;` |
| `go` | Go proxy | `github.com/gardusi-gustavo/kit` | `import "github.com/gardusi-gustavo/kit"` |
| `java` | Maven Central | `io.github.gardusi.gustavo:kit` | `import io.github.gardusi.gustavo.kit...` |
| `rb` | RubyGems | `gardusi-gustavo-kit` | `require "gardusi-gustavo/kit"` |
| `php` | Packagist | `gardusi-gustavo/kit` | `use Gardusi\Gustavo\Kit\...;` |
| `docker` | Docker Hub | `gardusi-gustavo/<role>` | `FROM gardusi-gustavo/python:0.1.0` |
| `yml` | — | YAML workflows | render into `.gitea/workflows/` |
| `git` | — | Git dotfile templates | generate `.gitignore`/`.gitattributes` |
| `html` | — | HTML layouts | copy document shells and components |
| `css` | — | CSS primitives | copy reset, tokens, layout, utilities |

If `gardusi-gustavo` is unavailable on a registry, choose one fallback identity and
record it in `dashboards/ops#168`. Do not use a different identity per
language.

## Scope rule

`0.1.0` ships one narrow capability that matches the language's strength. It is
not a utility grab-bag. Each repository records its scope, out-of-scope list,
and smoke test in `AGENTS.md`.

Use `templates/md/packages/AGENTS.md` as the starting point. The shared guardrails
still come from `sync-agents.sh`.

## Publish targets

`repo.json` declares the registry with `publish`:

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

`validate-publish-targets.sh` fails closed on an unknown target.

## CI profiles

`repo.json` also declares `ci.profile`. The renderer accepts `universal`,
`base`, `python`, `node`, `go`, `rust`, `cpp`, `java`, `media`, `dotnet`,
`ruby`, and `php`. The current runner advertises `ci-universal`; a repository
must use `universal` until the matching runner label exists.
