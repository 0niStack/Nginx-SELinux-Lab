#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"; need_root
echo "== Mode =="; getenforce
echo "== Labels =="; ls -Zd "$WEB_ROOT" "$UPLOAD_DIR" "$LOG_DIR" 2>&1 || true
echo "== httpd booleans (on) =="; getsebool -a | grep httpd | grep -- '--> on' || true
echo "== http_port_t =="; semanage port -l | grep '^http_port_t'
echo "== AVC denials =="; ausearch -m avc -ts recent 2>/dev/null | audit2why || echo "none"
echo "== nginx error log =="; tail -n 20 "$LOG_DIR/error.log" 2>/dev/null || tail -n 20 /var/log/nginx/error.log 2>/dev/null || true
echo
echo "Last resort custom module (review audit2allow output first!):"
echo "  ausearch -m avc -ts recent | audit2allow -M mynginx && semodule -i mynginx.pp"
