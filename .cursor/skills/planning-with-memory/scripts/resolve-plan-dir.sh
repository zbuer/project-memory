#!/usr/bin/env bash
# Resolve the directory that holds task_plan.md for this invocation.
# Priority: PLAN_ID under .planning/ → .active_plan → project root.
set -euo pipefail

ROOT="${PM_PLAN_ROOT:-${PWF_PLAN_ROOT:-$(pwd)}}"
cd "$ROOT"

if [[ -n "${PLAN_ID:-}" ]]; then
  # slug only; reject path traversal
  if [[ ! "$PLAN_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
    echo "[planning-with-memory] invalid PLAN_ID" >&2
    exit 1
  fi
  DIR="$ROOT/.planning/$PLAN_ID"
  if [[ ! -d "$DIR" ]]; then
    echo "[planning-with-memory] PLAN_ID not found: $PLAN_ID" >&2
    exit 1
  fi
  echo "$DIR"
  exit 0
fi

if [[ -f "$ROOT/.planning/.active_plan" ]]; then
  ACTIVE="$(tr -d '[:space:]' < "$ROOT/.planning/.active_plan")"
  if [[ -n "$ACTIVE" && -d "$ROOT/.planning/$ACTIVE" ]]; then
    echo "$ROOT/.planning/$ACTIVE"
    exit 0
  fi
fi

echo "$ROOT"
