#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"; need_root
add_fcontext() { # type path
  semanage fcontext -a -t "$1" "$2(/.*)?" 2>/dev/null || semanage fcontext -m -t "$1" "$2(/.*)?"
}
log "Labeling web root ($WEB_ROOT) as httpd_sys_content_t"
add_fcontext httpd_sys_content_t "$WEB_ROOT"
log "Labeling uploads ($UPLOAD_DIR) as httpd_sys_rw_content_t"
add_fcontext httpd_sys_rw_content_t "$UPLOAD_DIR"
log "Labeling logs ($LOG_DIR) as httpd_log_t"
add_fcontext httpd_log_t "$LOG_DIR"
if [ -d "$CERT_DIR" ]; then
  log "Labeling certs ($CERT_DIR) as cert_t"
  add_fcontext cert_t "$CERT_DIR"
  restorecon -Rv "$CERT_DIR"
fi
restorecon -Rv "$WEB_ROOT" "$LOG_DIR"
chown -R nginx:nginx "$UPLOAD_DIR"
ls -Zd "$WEB_ROOT" "$UPLOAD_DIR" "$LOG_DIR"
