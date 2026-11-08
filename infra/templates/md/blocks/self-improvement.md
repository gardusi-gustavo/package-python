## Self-improvement loop

Domain-audit repositories run a bounded audit:

- Inputs: README, AGENTS, docs index, file tree, open issues, and the coverage
  map.
- Roles: auditor, critic, and planner.
- Output: a report outside git and at most five issue drafts.
- Human review; `human` files selected drafts.
- No auto-filing, no repository edits, and no web facts.
- Private repositories use local models only.
- Cadence: weekly for active repositories, monthly for stable ones.
- A model upgrade is a trigger to rerun the audit.
