#!/usr/bin/env bash
# Read-only PR size check for CI. Runs only on pull_request events.
set -euo pipefail

ROOT="."
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    -h|--help) echo "usage: validate-pr-size.sh [--root PATH]"; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; exit 2 ;;
  esac
done
cd "$ROOT"

if [[ "${GITHUB_EVENT_NAME:-}" != "pull_request" ]]; then
  echo "pr size: skipped (not a pull request)"
  exit 0
fi

base="${GITHUB_BASE_REF:-main}"
repo="${GITHUB_REPOSITORY:-}"
pr=""
created=""
event="${GITHUB_EVENT_PATH:-}"

if [[ -n "$event" && -r "$event" ]]; then
  pr="$(jq -r '.pull_request.number // .number // empty' "$event" 2>/dev/null || true)"
  created="$(jq -r '.pull_request.created_at // empty' "$event" 2>/dev/null || true)"
  event_base="$(jq -r '.pull_request.base.ref // empty' "$event" 2>/dev/null || true)"
  [[ -n "$event_base" ]] && base="$event_base"
fi

if [[ -z "$pr" && "${GITHUB_REF:-}" =~ ^refs/pull/([0-9]+)/ ]]; then
  pr="${BASH_REMATCH[1]}"
fi

if [[ -z "$pr" ]]; then
  echo "pr size: skipped (no pull request number)"
  exit 0
fi

effective_from="2026-10-31"
# Bootstrap list for PRs that predate the budget. Remove after the queue clears.
grandfathered="private/journal#205"

for g in $grandfathered; do
  if [[ -n "$repo" && "$g" == "$repo#$pr" ]]; then
    echo "pr size: grandfathered $repo#$pr"
    exit 0
  fi
done

if [[ -n "$created" ]]; then
  created_date="${created%%T*}"
  if [[ "$created_date" < "$effective_from" ]]; then
    echo "pr size: grandfathered by date ($created_date < $effective_from)"
    exit 0
  fi
fi

base_ref="origin/$base"
if ! git rev-parse --verify "$base_ref" >/dev/null 2>&1; then
  if [[ -f .git/shallow ]]; then
    git fetch --no-tags --unshallow origin "$base" >/dev/null 2>&1 || true
  else
    git fetch --no-tags origin "$base" >/dev/null 2>&1 || true
  fi
fi
if ! git rev-parse --verify "$base_ref" >/dev/null 2>&1; then
  base_ref="$base"
fi
if ! git rev-parse --verify "$base_ref" >/dev/null 2>&1; then
  echo "pr size: cannot resolve base ref: $base" >&2
  exit 2
fi

base_cfg="$(git show "$base_ref:infra/config/repo.json" 2>/dev/null || echo '{}')"
max_files="$(jq -r '.pull_request_limits.max_files_changed // 12' <<<"$base_cfg")"
max_lines="$(jq -r '.pull_request_limits.max_changed_lines // 500' <<<"$base_cfg")"
max_single="$(jq -r '.pull_request_limits.max_single_file_lines // 250' <<<"$base_cfg")"
max_binary="$(jq -r '.pull_request_limits.max_binary_files // 1' <<<"$base_cfg")"
max_commits="$(jq -r '.pull_request_limits.max_commits // 12' <<<"$base_cfg")"

merge_base="$(git merge-base "$base_ref" HEAD)"
numstat="$(git diff --numstat "$merge_base" HEAD)"
files="$(grep -c . <<<"$numstat" || true)"
additions="$(awk '{a += $1} END {print a + 0}' <<<"$numstat")"
deletions="$(awk '{d += $2} END {print d + 0}' <<<"$numstat")"
max_file="$(awk '{v = $1 + $2; if (v > m) m = v} END {print m + 0}' <<<"$numstat")"
binary="$(awk '$1 == "-" {b++} END {print b + 0}' <<<"$numstat")"
commits="$(git rev-list --count "$merge_base..HEAD")"

reasons=()
if (( files > max_files )); then
  reasons+=("files: $files > $max_files")
fi
if (( additions + deletions > max_lines )); then
  reasons+=("changed lines: $((additions + deletions)) > $max_lines")
fi
if (( max_file > max_single )); then
  reasons+=("largest file: $max_file > $max_single")
fi
if (( binary > max_binary )); then
  reasons+=("binary files: $binary > $max_binary")
fi
if (( commits > max_commits )); then
  reasons+=("commits: $commits > $max_commits")
fi

if (( ${#reasons[@]} > 0 )); then
  echo "pr size: FAILED" >&2
  printf '  %s\n' "${reasons[@]}" >&2
  echo "  stats: files=$files lines=$((additions + deletions)) largest=$max_file binary=$binary commits=$commits" >&2
  echo "  split the change into follow-up issues; do not append to this PR" >&2
  exit 1
fi

echo "pr size: ok (files=$files lines=$((additions + deletions)) largest=$max_file binary=$binary commits=$commits)"
