#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
log "OS: $(. /etc/os-release && echo "$PRETTY_NAME")"
command -v getenforce >/dev/null || die "SELinux tools missing (install policycoreutils)."
MODE=$(getenforce)
log "SELinux mode: $MODE"
[ "$MODE" = "Enforcing" ] || warn "Not Enforcing. Fix: sudo setenforce 1 and set SELINUX=enforcing in /etc/selinux/config"
sestatus | sed 's/^/    /'
