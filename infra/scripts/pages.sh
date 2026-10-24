#!/usr/bin/env bash
# Build a minimal docs page for the current repository.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."
rm -rf public
mkdir -p public
if [[ -f README.md ]]; then
  {
    echo '<!doctype html><meta charset="utf-8">'
    echo '<title>workflows</title><pre>'
    sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' README.md
    echo '</pre>'
  } > public/index.html
fi
