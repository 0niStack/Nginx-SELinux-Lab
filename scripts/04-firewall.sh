#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"; need_root
[ "$OPEN_FIREWALL" = "1" ] || { warn "OPEN_FIREWALL=0, skipping"; exit 0; }
if systemctl is-active --quiet firewalld; then
  firewall-cmd --permanent --add-port="${LISTEN_PORT}/tcp"
  firewall-cmd --reload
  log "Opened ${LISTEN_PORT}/tcp"
else
  warn "firewalld not running, skipping"
fi
