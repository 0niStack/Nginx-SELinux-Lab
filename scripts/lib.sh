#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$ROOT_DIR/.env" ]; then set -a; . "$ROOT_DIR/.env"; set +a; fi
: "${SITE_NAME:=mysite}" "${WEB_ROOT:=/srv/mysite}" "${UPLOAD_DIR:=/srv/mysite/uploads}"
: "${LISTEN_PORT:=8081}" "${LOG_DIR:=/data/nginx/logs}" "${CERT_DIR:=/etc/ssl/mycerts}"
: "${ENABLE_PROXY:=0}" "${ALLOW_DB_ONLY:=0}" "${OPEN_FIREWALL:=1}"
log()  { printf '\033[1;32m[+]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }
need_root() { [ "$(id -u)" -eq 0 ] || die "Run as root (sudo)."; }
