# Infrastructure

Repository management for the toolkit.

| Path | Holds |
| --- | --- |
| `infra/config/` | repository contract and schemas |
| `infra/docker/` | consumer CI Dockerfile; shared images live in `templates/docker` |
| `infra/scripts/` | sync, check, release, and CI helpers |
| `templates/` | canonical base and AGENTS templates |

Application source does not live here. `src/` remains empty by convention.
