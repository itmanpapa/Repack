#!/usr/bin/env bash
# Клонирует upstream-репозитории Reseam на зафиксированных тегах в ./upstream/
# и печатает хеши коммитов для записи в AUDIT.md.
set -euo pipefail
cd "$(dirname "$0")/.."
source versions.env
mkdir -p upstream

fetch() {
  local name=$1 tag=$2
  if [[ -z "$tag" ]]; then
    echo "skip $name: тег не задан в versions.env" >&2
    return
  fi
  local dir="upstream/$name"
  if [[ ! -d "$dir/.git" ]]; then
    git clone --no-checkout "$RESEAM_BASE_URL/$name.git" "$dir"
  fi
  git -C "$dir" fetch --tags origin
  git -C "$dir" -c advice.detachedHead=false checkout --force "refs/tags/$tag"
  printf '%-18s %-10s %s\n' "$name" "$tag" "$(git -C "$dir" rev-parse HEAD)"
}

fetch reseam "$ENGINE_TAG"
fetch manager "$MANAGER_TAG"
fetch patches-template "$PATCHES_TEMPLATE_TAG"
