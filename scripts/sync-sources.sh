#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../config/build-config.env"

cd "${SOURCE_ROOT}"
repo sync \
  -c \
  --current-branch \
  --no-clone-bundle \
  --no-tags \
  --optimized-fetch \
  --prune \
  --force-sync \
  -j"${REPO_SYNC_JOBS}"

echo "Source sync complete"
