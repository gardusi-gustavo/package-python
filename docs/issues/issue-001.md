```json issue
{
  "schema": 1,
  "id": "issue-001",
  "title": "Publish python-etl to PyPI",
  "type": "enhancement",
  "status": "ready",
  "priority": "high",
  "areas": [
    "release"
  ],
  "labels": [
    "enhancement",
    "area:release",
    "priority:high"
  ],
  "created": "2026-10-23",
  "updated": "2026-10-23",
  "external_refs": {}
}
```

# Publish python-etl to PyPI

## Summary

Choose an available PyPI distribution name and prepare the package for its first release.

## Context

The package still uses a placeholder name and has never completed a PyPI release. PyPI and npm names must be available before publication, and release execution requires `PYPI_API_TOKEN` plus an approved `release` environment.

## Expected outcome

A clean virtual environment can install the published package from PyPI with the documented import path.

## Data model

None.

## Acceptance criteria

- [ ] The final PyPI name is recorded in `pyproject.toml` and the README.
- [ ] The wheel and source archive build locally.
- [ ] `twine check` passes.
- [ ] `PYPI_API_TOKEN` and the protected `release` environment are configured.
- [ ] The release workflow publishes successfully.
- [ ] A clean environment installs and imports the package from PyPI.

## Plan

- [ ] Check the candidate name on PyPI.
- [ ] Confirm package metadata, license, and import path.
- [ ] Build and inspect the artifacts.
- [ ] Configure the release secret and environment approval.
- [ ] Publish through the release workflow.
- [ ] Install from PyPI in a clean environment.

## Decisions

- 2026-10-23: Use the PyPI distribution name `python-etl-contracts`. The names `python-etl` and `python_etl` are already registered on PyPI; `python-etl-contracts` is available. The import package remains `python_etl`.

## Validation

- [ ] CI is green.
- [ ] Artifacts pass `twine check`.
- [ ] The published package installs in a clean environment.
- [ ] The repository is tagged and backed up.

## References

- `pyproject.toml`
- `scripts/release.sh`
- `.gitea/workflows/release.yml`
