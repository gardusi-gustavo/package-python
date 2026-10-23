```json issue
{
  "schema": 1,
  "id": "issue-001",
  "title": "Publish python-etl to PyPI",
  "type": "investigation",
  "status": "ready",
  "priority": "normal",
  "areas": ["release"],
  "labels": ["investigation", "area:release", "priority:normal"],
  "created": "2026-10-23",
  "updated": "2026-10-23",
  "external_refs": {}
}
```

# Publish python-etl to PyPI

## Summary

Choose an available PyPI distribution name and prepare the package for its first release.

## Context

A clean environment can install the released package.

## Expected outcome

A clean environment can install the released package.

## Data model

None.

## Acceptance criteria

- [ ] The required secret or publication path is configured.
- [ ] The release workflow completes successfully.
- [ ] The published artifact can be consumed by a clean environment.

## Plan

- [ ] Check PyPI name availability
- [ ] Confirm pyproject metadata
- [ ] Configure PYPI_API_TOKEN
- [ ] Run the release workflow
- [ ] Install from PyPI in a clean environment

## Decisions

None yet.

## Validation

- [ ] CI is green.
- [ ] Release output is verified.
- [ ] The repository is tagged and backed up.

## References

None.
