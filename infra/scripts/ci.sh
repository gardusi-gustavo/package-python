#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."
PYTHONPATH=src python3 -m compileall -q src src/tests
PYTHONPATH=src python3 -m pytest -q src/tests
