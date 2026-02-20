#!/usr/bin/env bash
set -e

VERSION="4.13"
URL="https://github.com/seaweedfs/seaweedfs/releases/download/${VERSION}/linux_amd64.tar.gz"
TARGET_DIR="${HOME}/.local/bin"
TARGET_BIN="${TARGET_DIR}/weed"
TMP_DIR="$(mktemp -d)"

trap 'rm -rf "${TMP_DIR}"' EXIT

mkdir -p "${TARGET_DIR}"
curl -sL "${URL}" -o "${TMP_DIR}/seaweedfs.tar.gz"
tar -xzf "${TMP_DIR}/seaweedfs.tar.gz" -C "${TMP_DIR}"
mv "${TMP_DIR}/weed" "${TARGET_BIN}"
chmod +x "${TARGET_BIN}"

if echo ":${PATH}:" | grep -q ":${TARGET_DIR}:"; then
  echo "Installed. Run: weed"
else
  echo "Installed to ${TARGET_BIN}"
  echo "Add to PATH (e.g. in ~/.bashrc): export PATH=\"\${HOME}/.local/bin:\${PATH}\""
  echo "Then run: weed"
fi
