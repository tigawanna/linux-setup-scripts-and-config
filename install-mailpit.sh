#!/usr/bin/env bash
set -e

VERSION="v1.29.1"
URL="https://github.com/axllent/mailpit/releases/download/${VERSION}/mailpit-linux-amd64.tar.gz"
TARGET_DIR="${HOME}/.local/bin"
TARGET_BIN="${TARGET_DIR}/mailpit"
TMP_DIR="$(mktemp -d)"

trap 'rm -rf "${TMP_DIR}"' EXIT

mkdir -p "${TARGET_DIR}"
curl -sL "${URL}" -o "${TMP_DIR}/mailpit.tar.gz"
tar -xzf "${TMP_DIR}/mailpit.tar.gz" -C "${TMP_DIR}"
mv "${TMP_DIR}/mailpit" "${TARGET_BIN}"
chmod +x "${TARGET_BIN}"

if echo ":${PATH}:" | grep -q ":${TARGET_DIR}:"; then
  echo "Installed. Run: mailpit"
else
  echo "Installed to ${TARGET_BIN}"
  echo "Add to PATH (e.g. in ~/.bashrc): export PATH=\"\${HOME}/.local/bin:\${PATH}\""
  echo "Then run: mailpit"
fi

