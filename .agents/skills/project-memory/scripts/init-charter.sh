#!/usr/bin/env bash
# Create or ensure charter exists (does not overwrite existing CHARTER.md body).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec bash "$SCRIPT_DIR/ensure-memory.sh" --with-charter
