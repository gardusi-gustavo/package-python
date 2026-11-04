#!/usr/bin/env bash
# Platform-neutral CI entrypoint. Runs in the consuming repository.
set -euo pipefail
ROOT="${CI_PROJECT_DIR:-$PWD}"
cd "$ROOT"

if [[ "${GITHUB_EVENT_NAME:-}" == "pull_request" && -x infra/scripts/ci/validate-md-links.sh ]]; then
  bash infra/scripts/ci/validate-md-links.sh \
    --root "$ROOT" --changed --base "origin/${GITHUB_BASE_REF:-main}" --check
fi

if [[ -x infra/scripts/ci/validate-risk.sh ]]; then
  bash infra/scripts/ci/validate-risk.sh --root "$ROOT"
fi

if [[ "${GITHUB_EVENT_NAME:-}" == "pull_request" && -n "${GITEA_TOKEN:-}" && -r "${GITHUB_EVENT_PATH:-}" ]]; then
  pr_number="$(jq -r '.pull_request.number // .number // empty' "$GITHUB_EVENT_PATH")"
  if [[ -n "$pr_number" ]]; then
    bash infra/scripts/ci/validate-pr-count.sh \
      --repo "${GITHUB_REPOSITORY:?}" --pr "$pr_number" \
      --token "$GITEA_TOKEN" --api "${GITEA_URL:-${GITHUB_SERVER_URL:-http://gitea.localhost:3001}}"
  fi
fi

[[ -f infra/docker/ci.dockerfile ]] || { echo "missing infra/docker/ci.dockerfile" >&2; exit 1; }

tag="ci-$(git rev-parse --short HEAD)-$$"
cid="ci-${GITHUB_RUN_ID:-${CI_PIPELINE_ID:-$$}}"
cleanup() { docker rm -f "$cid" >/dev/null 2>&1 || true; }
trap cleanup EXIT

docker build -f infra/docker/ci.dockerfile -t "$tag" .
docker create --name "$cid" "$tag"
docker cp "$ROOT/." "$cid:/repo"
docker start -a "$cid"
