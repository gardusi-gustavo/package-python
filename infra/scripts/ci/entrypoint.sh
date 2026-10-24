#!/usr/bin/env bash
# Platform-neutral CI entrypoint. Runs in the consuming repository.
set -euo pipefail
ROOT="${CI_PROJECT_DIR:-$PWD}"
cd "$ROOT"

[[ -f infra/docker/ci.dockerfile ]] || { echo "missing infra/docker/ci.dockerfile" >&2; exit 1; }
CI_REGISTRY="${CI_REGISTRY:-}"

tag="ci-$(git rev-parse --short HEAD)-$$"
cid="ci-${GITHUB_RUN_ID:-${CI_PIPELINE_ID:-$$}}"
cleanup() { docker rm -f "$cid" >/dev/null 2>&1 || true; }
trap cleanup EXIT

docker build --build-arg "CI_REGISTRY=$CI_REGISTRY" -f infra/docker/ci.dockerfile -t "$tag" .
docker create --name "$cid" "$tag"
docker cp "$ROOT/." "$cid:/repo"
docker start -a "$cid"
