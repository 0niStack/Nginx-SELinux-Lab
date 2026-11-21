#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"; need_root
nginx -t
systemctl enable nginx
systemctl restart nginx
sleep 1
log "Process context (expect httpd_t):"
ps -eZ | grep '[n]ginx' | head -3
log "HTTP check on :$LISTEN_PORT"
curl -fsS -o /dev/null -w "HTTP %{http_code}\n" "http://127.0.0.1:${LISTEN_PORT}/" \
  || warn "Request failed, run: make troubleshoot"
log "Recent AVC denials:"
ausearch -m avc -ts recent 2>/dev/null | tail -n 20 || echo "none"
