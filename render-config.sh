#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$SCRIPT_DIR/.env" ]; then
  echo "ERROR: .env file not found. Copy .env.template to .env and fill in values."
  exit 1
fi

# shellcheck disable=SC1091
set -a
source "$SCRIPT_DIR/.env"
set +a

echo "Rendering hermes config templates..."

# Render each .tpl file into its .yaml counterpart
for tpl in "$SCRIPT_DIR"/config/*.yaml.tpl; do
  [ -f "$tpl" ] || continue
  out="${tpl%.tpl}"
  envsubst < "$tpl" > "$out"
  echo "  $(basename "$out")"
done

echo "Config rendered successfully."
