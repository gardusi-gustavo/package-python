#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
version="${1:-${VERSION:-}}"
[[ -n "$version" ]] || { echo "usage: release.sh <version>" >&2; exit 2; }
python3 -m build
python3 -m twine check dist/*
python3 -m twine upload dist/* -u __token__ -p "${PYPI_API_TOKEN:?}"
