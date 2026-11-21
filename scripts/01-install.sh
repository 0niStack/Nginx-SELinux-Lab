#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"; need_root
log "Installing nginx and SELinux management tools"
dnf install -y nginx policycoreutils-python-utils setroubleshoot-server audit
systemctl enable --now auditd || true
log "Deploying site config and content"
mkdir -p "$WEB_ROOT" "$UPLOAD_DIR" "$LOG_DIR"
cp -r "$ROOT_DIR/html/." "$WEB_ROOT/"
sed -e "s|__PORT__|$LISTEN_PORT|g" -e "s|__ROOT__|$WEB_ROOT|g" -e "s|__LOGDIR__|$LOG_DIR|g" \
  "$ROOT_DIR/config/nginx/conf.d/site.conf" > "/etc/nginx/conf.d/$SITE_NAME.conf"
if [ "$ENABLE_PROXY" = "1" ]; then
  cp "$ROOT_DIR/config/nginx/conf.d/proxy.conf.example" "/etc/nginx/conf.d/${SITE_NAME}-proxy.conf"
fi
