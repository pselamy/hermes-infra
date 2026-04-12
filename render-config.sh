#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$SCRIPT_DIR/.env" ]; then
  echo "ERROR: .env file not found. Copy .env.example to .env and fill in values."
  exit 1
fi

# shellcheck disable=SC1091
source "$SCRIPT_DIR/.env"

echo "Rendering config for domain: ${DOMAIN}"

mkdir -p "$SCRIPT_DIR/config/dynamic"

# Render traefik static config
cat > "$SCRIPT_DIR/config/traefik.yml" <<EOF
api:
  dashboard: true
  insecure: true

entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https
  websecure:
    address: ":443"

certificatesResolvers:
  letsencrypt:
    acme:
      email: ${ACME_EMAIL}
      storage: /letsencrypt/acme.json
      httpChallenge:
        entryPoint: web

providers:
  docker:
    exposedByDefault: false
  file:
    directory: /etc/traefik/dynamic
    watch: true

ping:
  entryPoint: web

log:
  level: ${LOG_LEVEL}
EOF

# Render dynamic config
cat > "$SCRIPT_DIR/config/dynamic/dashboard.yml" <<EOF
http:
  routers:
    dashboard:
      rule: "Host(\`traefik.${DOMAIN}\`)"
      service: api@internal
      entryPoints:
        - websecure
      tls:
        certResolver: letsencrypt
EOF

echo "Config rendered successfully."
