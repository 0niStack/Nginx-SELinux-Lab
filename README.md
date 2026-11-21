# nginx-selinux

Run Nginx on an SELinux **Enforcing** host (RHEL, AlmaLinux, Rocky, Fedora) without disabling SELinux.
Handles file labels, booleans, custom ports, logs, certs, firewall and Docker bind mounts.

## Layout
```
nginx-selinux/
├── Makefile
├── .env.example
├── config/nginx/            site.conf, proxy.conf.example, docker.conf
├── html/                    sample site
├── scripts/                 numbered, idempotent setup scripts
├── ansible/                 same setup as a playbook
├── docker/                  compose with :z relabel flags
└── docs/TROUBLESHOOTING.md
```

## Quick start (bash)
```bash
cp .env.example .env && vi .env
make all
```
Step by step: `make preflight install labels booleans firewall verify`.

## What each step does
1. **preflight**: checks SELinux is Enforcing.
2. **install**: installs nginx and SELinux tools, deploys config and site.
3. **labels**: `httpd_sys_content_t` (content), `httpd_sys_rw_content_t` (uploads), `httpd_log_t` (logs), `cert_t` (certs), via `semanage fcontext` + `restorecon`.
4. **booleans**: `httpd_can_network_connect` (reverse proxy, when `ENABLE_PROXY=1`) or `httpd_can_network_connect_db`; adds `LISTEN_PORT` to `http_port_t`.
5. **firewall**: opens the port in firewalld.
6. **verify**: `nginx -t`, restart, confirms `httpd_t`, curls the site, shows recent AVC denials.

## Reverse proxy
Set `ENABLE_PROXY=1`, edit `config/nginx/conf.d/proxy.conf.example` (upstream, listen port).
If the proxy listens on a non-standard port such as 8082, add it too:
`sudo semanage port -a -t http_port_t -p tcp 8082`

## Ansible
```bash
cd ansible
cp inventory.ini.example inventory.ini
ansible-galaxy collection install ansible.posix community.general
ansible-playbook -i inventory.ini playbook.yml -e enable_proxy=true
```

## Docker
```bash
make docker-up     # http://localhost:8080
```

## Troubleshooting
`make troubleshoot` or see `docs/TROUBLESHOOTING.md`.
Only as a last resort, build a custom module from real denials with `audit2allow`.
