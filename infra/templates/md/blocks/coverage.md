## Coverage

Domain-audit repositories keep a coverage map at `src/data/coverage.json` and a
human view at `docs/coverage.md`.

- One row per topic.
- Status: `covered`, `partial`, `missing`, or `stale`.
- `covered` and `partial` require a `ref`.
- Review rows when the domain changes or a model upgrade reveals a gap.
- The coverage map is the durable counterpart to the model's knowledge.
- The schema is `infra/config/coverage.schema.json`; run
  `infra/scripts/ci/validate-coverage.sh`.
