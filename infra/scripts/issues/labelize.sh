#!/usr/bin/env bash
# Derive the readiness label from status and blockers.
set -euo pipefail

ROOT="."
MODE="check"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    --check) MODE="check"; shift ;;
    --fix) MODE="fix"; shift ;;
    -h|--help) echo "usage: labelize.sh [--check|--fix] [--root PATH]"; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; exit 2 ;;
  esac
done
cd "$ROOT"

json_block() { awk '/^```json/{flag=1;next}/^```/{if(flag)exit}flag' "$1"; }
readiness() {
  local status="$1" blocked="$2" waiting="$3"
  case "$status" in
    done|dropped) echo closed ;;
    in-progress) echo active ;;
    ready)
      if [[ "$blocked" == "0" && "$waiting" == "0" ]]; then echo ready; else echo not-ready; fi
      ;;
    *) echo not-ready ;;
  esac
}

changed=0
shopt -s nullglob
for f in docs/issues/issue-*.md docs/issues/question-*.md; do
  [[ -f "$f" ]] || continue
  case "$(basename "$f")" in template.md|question-template.md) continue ;; esac
  block="$(json_block "$f")"
  if [[ -z "$block" ]]; then
    echo "ERROR: $f: missing fenced json block" >&2
    exit 1
  fi
  if ! json="$(printf '%s\n' "$block" | jq -c . 2>/dev/null)"; then
    echo "ERROR: $f: invalid JSON in fenced block" >&2
    exit 1
  fi

  status="$(jq -r '.status // ""' <<<"$json")"
  type="$(jq -r '.type // ""' <<<"$json")"
  priority="$(jq -r '.priority // ""' <<<"$json")"
  blocked="$(jq -r '.blocked_by | if type == "array" then length else 0 end' <<<"$json")"
  waiting="$(jq -r '.waiting_on | if type == "array" then length else 0 end' <<<"$json")"
  want="$(readiness "$status" "$blocked" "$waiting")"

  expected="$(jq -c --arg r "$want" --arg t "type:$type" --arg p "priority:$priority" '
    [ $r, $t, (.areas[]? | "area:" + .), $p ] | unique
  ' <<<"$json")"
  current="$(jq -c '.labels | sort' <<<"$json")"

  if [[ "$current" != "$expected" ]]; then
    if [[ "$MODE" == "check" ]]; then
      echo "ERROR: $f: labels are stale" >&2
      echo "  current:  $current" >&2
      echo "  expected: $expected" >&2
      changed=1
    else
      newjson="$(jq -c --argjson labels "$expected" '.labels = $labels' <<<"$json")"
      start="$(grep -n '^```json' "$f" | head -1 | cut -d: -f1)"
      end="$(awk -v s="$start" 'NR>s && /^```/{print NR; exit}' "$f")"
      tmp="$(mktemp)"
      head -n "$start" "$f" > "$tmp"
      printf '%s\n' "$newjson" | jq --indent 2 . >> "$tmp"
      tail -n +"$end" "$f" >> "$tmp"
      mv "$tmp" "$f"
      echo "fixed $f"
    fi
  fi
done

if [[ "$MODE" == "check" && "$changed" -ne 0 ]]; then
  exit 1
fi
echo "labels ok"
