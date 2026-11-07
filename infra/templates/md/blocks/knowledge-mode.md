## Knowledge mode

Declare the repository's knowledge mode in `infra/config/repo.json`:

- `observer` — broad, fuzzy, exploratory signals. One per ecosystem; requires a
  source list and a priority queue.
- `instrument` — fixed sources, measured data, high accuracy. AI must not be in
  the data path.
- `domain-audit` — repository knowledge compared to a domain model. Requires a
  coverage map and an AI loop.
- `mirror` — read-only copy of an upstream repository.

Rules:

- Observers never claim accuracy; promoted items leave the repository
  explicitly.
- Instruments fail closed on stale, missing, or inconsistent data.
- Domain audits draft issues; they never file or edit.
- Private repositories use local-only models.
- The mode is part of the repository contract; change it with an ADR.
