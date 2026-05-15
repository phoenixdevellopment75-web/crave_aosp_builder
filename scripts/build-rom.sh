#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../config/build-config.env"

export USE_CCACHE=1
export CCACHE_EXEC="$(command -v ccache)"
export CCACHE_DIR="${CCACHE_DIR}"
export CCACHE_COMPRESS=1
export CCACHE_COMPRESSLEVEL=1

mkdir -p "${ARTIFACTS_DIR}" "${LOGS_DIR}"
ccache -M "${CCACHE_MAXSIZE}" || true
ccache -z || true

cd "${SOURCE_ROOT}"

source build/envsetup.sh
lunch "${BUILD_TARGET}"

{
  echo "ROM_NAME=${ROM_NAME}"
  echo "ROM_BRANCH=${ROM_BRANCH}"
  echo "DEVICE_CODENAME=${DEVICE_CODENAME}"
  echo "BUILD_TARGET=${BUILD_TARGET}"
  echo "BUILD_COMMAND=${BUILD_COMMAND}"
  echo "REPO_SYNC_JOBS=${REPO_SYNC_JOBS}"
  echo "BUILD_JOBS=${BUILD_JOBS}"
  echo "CCACHE_MAXSIZE=${CCACHE_MAXSIZE}"
  echo "START_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} | tee "${LOGS_DIR}/build-context.txt"

export NINJA_ARGS="-j${BUILD_JOBS} -l${BUILD_JOBS}"
export MAKEFLAGS="-j${BUILD_JOBS}"
export SOONG_UI_NINJA_ARGS="${NINJA_ARGS}"
export NINJA_STATUS="[%r/%f/%u | %o/sec] "

${BUILD_COMMAND} -j"${BUILD_JOBS}" 2>&1 | tee "${LOGS_DIR}/build.log"

ccache -s | tee "${LOGS_DIR}/ccache-stats.txt" || true

echo "Build finished"
