#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../config/build-config.env"

PRODUCT_DIR="${SOURCE_ROOT}/out/target/product/${DEVICE_CODENAME}"
mkdir -p "${ARTIFACTS_DIR}"

if [[ ! -d "${PRODUCT_DIR}" ]]; then
  echo "Product directory not found: ${PRODUCT_DIR}" >&2
  exit 1
fi

find "${PRODUCT_DIR}" -maxdepth 1 -type f \
  \( -name "*.zip" -o -name "*.img" -o -name "*.txt" -o -name "*.json" -o -name "*.sha256sum" -o -name "*.md5sum" \) \
  -exec cp -f {} "${ARTIFACTS_DIR}/" \;

ls -lah "${ARTIFACTS_DIR}" | tee "${ARTIFACTS_DIR}/artifact-list.txt"

