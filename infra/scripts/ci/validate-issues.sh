#!/usr/bin/env bash
# Validate the durable issue records in docs/issues/.
set -euo pipefail

ROOT="."
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    -h|--help) echo "usage: validate-issues.sh [--root PATH]"; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; exit 2 ;;
  esac
done
cd "$ROOT"

errors=0
fail() { echo "ERROR: $*" >&2; errors=$((errors+1)); }
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

[[ -d docs/issues ]] || { echo "ERROR: missing docs/issues/" >&2; exit 1; }
for d in docs/wishlist docs/problems docs/questions; do
  [[ -e "$d" ]] && fail "forbidden directory: $d/"
done

repo_name="$(jq -r '.name // ""' infra/config/repo.json 2>/dev/null || true)"
uuid_re='^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'
seen="$(mktemp)"
trap 'rm -f "$seen"' EXIT

shopt -s nullglob
for f in docs/issues/issue-*.md docs/issues/question-*.md; do
  [[ -f "$f" ]] || continue
  case "$(basename "$f")" in template.md|question-template.md) continue ;; esac
  base="$(basename "$f" .md)"
  block="$(json_block "$f")"
  if [[ -z "$block" ]]; then
    fail "$f: missing fenced json block"
    continue
  fi
  if ! json="$(printf '%s\n' "$block" | jq -c . 2>/dev/null)"; then
    fail "$f: invalid JSON in fenced block"
    continue
  fi

  for key in schema id title type status priority areas labels blocked_by waiting_on created updated external_refs; do
    jq -e "has(\"$key\")" <<<"$json" >/dev/null || fail "$f: missing key $key"
  done

  schema="$(jq -r '.schema // ""' <<<"$json")"
  id="$(jq -r '.id // ""' <<<"$json")"
  title="$(jq -r '.title // ""' <<<"$json")"
  type="$(jq -r '.type // ""' <<<"$json")"
  status="$(jq -r '.status // ""' <<<"$json")"
  priority="$(jq -r '.priority // ""' <<<"$json")"
  created="$(jq -r '.created // ""' <<<"$json")"
  updated="$(jq -r '.updated // ""' <<<"$json")"
  blocked="$(jq -r '.blocked_by | if type == "array" then length else -1 end' <<<"$json")"
  waiting="$(jq -r '.waiting_on | if type == "array" then length else -1 end' <<<"$json")"

  [[ "$schema" == "1" ]] || fail "$f: schema must be 1"
  [[ -n "$title" ]] || fail "$f: title must not be empty"
  [[ "$created" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || fail "$f: created must be YYYY-MM-DD"
  [[ "$updated" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || fail "$f: updated must be YYYY-MM-DD"
  [[ "$id" =~ $uuid_re ]] || fail "$f: id is not a UUID: $id"

  case "$type" in
    bug|enhancement|task|initiative|investigation|question) ;;
    *) fail "$f: invalid type: $type" ;;
  esac
  case "$status" in
    idea|backlog|blocked|ready|in-progress|done|dropped) ;;
    *) fail "$f: invalid status: $status" ;;
  esac
  case "$priority" in
    low|normal|high|critical) ;;
    *) fail "$f: invalid priority: $priority" ;;
  esac

  jq -e '.areas | type == "array" and length > 0' <<<"$json" >/dev/null || fail "$f: areas must be a non-empty array"
  jq -e '.labels | type == "array"' <<<"$json" >/dev/null || fail "$f: labels must be an array"
  jq -e '.blocked_by | type == "array"' <<<"$json" >/dev/null || fail "$f: blocked_by must be an array"
  jq -e '.waiting_on | type == "array"' <<<"$json" >/dev/null || fail "$f: waiting_on must be an array"
  jq -e '.external_refs | type == "object"' <<<"$json" >/dev/null || fail "$f: external_refs must be an object"

  expected_prefix="issue"
  [[ "$type" == "question" ]] && expected_prefix="question"
  [[ "$base" == "$expected_prefix-$id" ]] || fail "$f: filename must be $expected_prefix-$id.md"

  if grep -qx "$id" "$seen"; then
    fail "$f: duplicate id $id"
  else
    echo "$id" >> "$seen"
  fi

  if [[ "$type" == "question" ]]; then
    for section in Question "Current baseline" Options Recommendation Decision "Acceptance criteria" References; do
      grep -q "^## $section$" "$f" || fail "$f: missing section: ## $section"
    done
  else
    for section in Summary Context "Expected outcome" "Out of scope" "Data model" "Acceptance criteria" Plan Decisions Validation References; do
      grep -q "^## $section$" "$f" || fail "$f: missing section: ## $section"
    done
  fi

  if [[ "$status" == "ready" && "$blocked" != "0" ]]; then
    fail "$f: status ready with blocked_by entries; use status blocked"
  fi
  if [[ "$status" == "ready" && "$waiting" != "0" ]]; then
    fail "$f: status ready with waiting_on entries; use status blocked"
  fi

  want="$(readiness "$status" "$blocked" "$waiting")"
  jq -e --arg l "$want" '.labels | index($l)' <<<"$json" >/dev/null || fail "$f: labels missing readiness label $want"
  jq -e --arg l "type:$type" '.labels | index($l)' <<<"$json" >/dev/null || fail "$f: labels missing type:$type"
  jq -e --arg l "priority:$priority" '.labels | index($l)' <<<"$json" >/dev/null || fail "$f: labels missing priority:$priority"
  while IFS= read -r area; do
    [[ -n "$area" ]] || continue
    jq -e --arg l "area:$area" '.labels | index($l)' <<<"$json" >/dev/null || fail "$f: labels missing area:$area"
  done < <(jq -r '.areas[]?' <<<"$json")
done

for f in docs/issues/*; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  case "$base" in
    template.md|question-template.md)
      [[ "$repo_name" == "templates" ]] || fail "template file belongs in public/templates only: $f"
      ;;
    issue-*.md|question-*.md) ;;
    *) fail "unexpected file in docs/issues/: $f" ;;
  esac
done

if [[ -x infra/scripts/issues/labelize.sh ]]; then
  infra/scripts/issues/labelize.sh --check --root . || fail "readiness labels are stale; run labelize.sh --fix"
fi

(( errors == 0 )) || exit 1
echo "issues contract ok"
