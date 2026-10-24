#!/usr/bin/env bash
set -euo pipefail
ROOT="${CI_PROJECT_DIR:-$(git rev-parse --show-toplevel)}"
cd "$ROOT"
PYTHONPATH=src python3 -m compileall -q src src/tests
PYTHONPATH=src python3 -m pytest -q src/tests
