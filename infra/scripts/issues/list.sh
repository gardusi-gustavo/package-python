#!/usr/bin/env bash
# List issue and question records by derived readiness.
set -euo pipefail

ROOT="."
FILTER="all"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    --ready) FILTER="ready"; shift ;;
    --not-ready|--not_ready) FILTER="not-ready"; shift ;;
    --active) FILTER="active"; shift ;;
    --closed) FILTER="closed"; shift ;;
    --all) FILTER="all"; shift ;;
    -h|--help)
      echo "usage: list.sh [--ready|--not-ready|--active|--closed|--all] [--root PATH]"
      exit 0
      ;;
    *) echo "error: unknown argument: $1" >&2; exit 2 ;;
  esac
done
cd "$ROOT"

json_block() { awk '/^```json/{flag=1;next}/^```/{if(flag)exit}flag' "$1"; }

shopt -s nullglob
for f in docs/issues/issue-*.md docs/issues/question-*.md; do
  [[ -f "$f" ]] || continue
  case "$(basename "$f")" in template.md|question-template.md) continue ;; esac
  block="$(json_block "$f")"
  [[ -n "$block" ]] || continue
  json="$(printf '%s\n' "$block" | jq -c . 2>/dev/null)" || continue
  id="$(jq -r '.id // ""' <<<"$json")"
  title="$(jq -r '.title // ""' <<<"$json")"
  label="$(jq -r '.labels[]? | select(. == "ready" or . == "not-ready" or . == "active" or . == "closed")' <<<"$json" | head -1)"
  [[ -n "$label" ]] || label="unlabeled"
  if [[ "$FILTER" == "all" || "$FILTER" == "$label" ]]; then
    printf '%s\t%s\t%s\t%s\n' "$label" "$id" "$title" "$f"
  fi
done | sort
