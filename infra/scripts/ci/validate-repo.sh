#!/usr/bin/env bash
# Validate a repository against its infra/config/repo.json contract.
set -euo pipefail

ROOT="."
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    -h|--help) echo "usage: validate-repo.sh [--root PATH]"; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; exit 2 ;;
  esac
done
cd "$ROOT"
CONFIG="infra/config/repo.json"
errors=0
fail() { echo "ERROR: $*" >&2; errors=$((errors+1)); }

[[ -s "$CONFIG" ]] || { echo "missing $CONFIG" >&2; exit 1; }
jq empty "$CONFIG" >/dev/null || { echo "invalid JSON: $CONFIG" >&2; exit 1; }

visibility="$(jq -r '.visibility' "$CONFIG")"
pages="$(jq -r '.features.pages // false' "$CONFIG")"
[[ "$visibility" == "public" || "$visibility" == "private" ]] || fail "visibility must be public or private"
[[ "$(jq -r '.schema' "$CONFIG")" == "1" ]] || fail "unsupported schema"

for f in README.md .gitattributes .gitignore .dockerignore "$CONFIG" infra/docker/ci.dockerfile infra/scripts/ci.sh infra/scripts/ci/validate-files.sh docs/README.md; do
  [[ -s "$f" ]] || fail "missing required file: $f"
done

if [[ "$pages" == "true" ]]; then
  for f in infra/docker/pages.dockerfile infra/scripts/pages.sh; do
    [[ -s "$f" ]] || fail "pages enabled but missing: $f"
  done
fi

while IFS= read -r f; do
  case "$f" in infra/scripts/*.sh) ;; *) fail "shell script outside infra/scripts/: $f" ;; esac
done < <(git ls-files '*.sh')

while IFS= read -r f; do
  case "$f" in infra/docker/*.dockerfile) ;; *) fail "Dockerfile outside infra/docker/: $f" ;; esac
done < <(git ls-files | grep -E '(^|/)Dockerfile$|\.Dockerfile$|\.dockerfile$' || true)

while IFS= read -r f; do
  case "$f" in
    .vscode/*|.idea/*|.devcontainer/*|.editorconfig|*/.*) fail "editor/container file must not be tracked: $f" ;;
  esac
done < <(git ls-files | grep -E '(^|/)(\.vscode|\.idea|\.devcontainer)/|(^|/)\.editorconfig$' || true)

while IFS= read -r f; do
  case "$f" in *.json) ;; *) fail "infra/config/ must contain only JSON: $f" ;; esac
done < <(git ls-files 'infra/config/**' || true)

while IFS= read -r f; do
  case "$f" in *.md) ;; *) fail "docs/ must contain only Markdown: $f" ;; esac
done < <(git ls-files 'docs/**' || true)

infra/scripts/ci/validate-files.sh --root . --config "$CONFIG"

max_repo="$(jq -r '.limits.repo_mb // 100' "$CONFIG")"
max_file="$(jq -r '.limits.file_mb // 25' "$CONFIG")"
total="$(git ls-files -z | xargs -0 -r stat -c '%s' | awk '{s+=$1} END {print s+0}')"
if (( total > max_repo * 1000000 )); then fail "repo size ${total} exceeds ${max_repo} MB"; fi
largest=$(git ls-files -z | xargs -0 -r stat -c '%s %n' | awk 'BEGIN {m=0} $1>m {m=$1; f=$0} END {if (m>0) print f}')
if [[ -n "$largest" ]]; then
  size=${largest%% *}; file=${largest#* }
  if (( size > max_file * 1000000 )); then fail "file ${file} exceeds ${max_file} MB"; fi
fi

readme_max="$(jq -r '.readme.max_lines // 80' "$CONFIG")"
lines="$(wc -l < README.md)"
(( lines <= readme_max )) || fail "README.md is ${lines} lines; max ${readme_max}"

(( errors == 0 )) || exit 1
if [[ -x infra/scripts/check-layout.sh ]]; then
  infra/scripts/check-layout.sh --root .
fi
echo "repo contract ok: $visibility"
