#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../config/build-config.env"

mkdir -p "${SOURCE_ROOT}" "${ARTIFACTS_DIR}" "${LOGS_DIR}" "${CCACHE_DIR}"

if [[ ! -d "${SOURCE_ROOT}/.repo" ]]; then
  repo init -u "${MANIFEST_URL}" -b "${MANIFEST_BRANCH}" --git-lfs --depth="${REPO_DEPTH}"
fi

mkdir -p "${SOURCE_ROOT}/.repo/local_manifests"
cp -f "$(dirname "$0")/../manifests/crosshatch.xml" "${SOURCE_ROOT}/.repo/local_manifests/crosshatch.xml"

echo "Repository bootstrap complete"
