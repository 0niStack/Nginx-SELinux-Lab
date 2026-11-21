# Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| 403 on static files | Wrong file label | `semanage fcontext -a -t httpd_sys_content_t "/path(/.*)?"` then `restorecon -Rv /path` |
| 502 to backend, "Permission denied" in error log | Proxy boolean off | `setsebool -P httpd_can_network_connect 1` |
| Nginx fails to bind port | Port not in http_port_t | `semanage port -a -t http_port_t -p tcp PORT` |
| Cannot write logs/uploads | Wrong type | `httpd_log_t` for logs, `httpd_sys_rw_content_t` for uploads |
| Cannot read certs | Wrong type | `semanage fcontext -a -t cert_t "/path(/.*)?"` |
| Docker bind mount denied | No relabel flag | Add `:z` or `:Z` to volume |

## Useful commands
```bash
ausearch -m avc -ts recent | audit2why
journalctl -t setroubleshoot
getsebool -a | grep httpd
ls -Z /path
ps -eZ | grep nginx
```
`chcon` is lost on relabel. Always use `semanage fcontext` + `restorecon`.
