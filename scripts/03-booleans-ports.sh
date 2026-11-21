#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"; need_root
if [ "$ENABLE_PROXY" = "1" ]; then
  if [ "$ALLOW_DB_ONLY" = "1" ]; then
    log "Setting httpd_can_network_connect_db=on"
    setsebool -P httpd_can_network_connect_db 1
  else
    log "Setting httpd_can_network_connect=on"
    setsebool -P httpd_can_network_connect 1
  fi
fi
if semanage port -l | awk '$1=="http_port_t"' | grep -qw "$LISTEN_PORT"; then
  log "Port $LISTEN_PORT already allowed for http_port_t"
else
  log "Adding tcp/$LISTEN_PORT to http_port_t"
  semanage port -a -t http_port_t -p tcp "$LISTEN_PORT" 2>/dev/null \
    || semanage port -m -t http_port_t -p tcp "$LISTEN_PORT"
fi
