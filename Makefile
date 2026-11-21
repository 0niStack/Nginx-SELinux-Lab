SHELL := /bin/bash
.PHONY: all preflight install labels booleans firewall verify troubleshoot clean docker-up docker-down
all: preflight install labels booleans firewall verify
preflight:
	sudo ./scripts/00-preflight.sh
install:
	sudo ./scripts/01-install.sh
labels:
	sudo ./scripts/02-selinux-labels.sh
booleans:
	sudo ./scripts/03-booleans-ports.sh
firewall:
	sudo ./scripts/04-firewall.sh
verify:
	sudo ./scripts/05-verify.sh
troubleshoot:
	sudo ./scripts/99-troubleshoot.sh
docker-up:
	cd docker && docker compose up -d
docker-down:
	cd docker && docker compose down
clean:
	sudo systemctl stop nginx || true
	sudo rm -f /etc/nginx/conf.d/$${SITE_NAME:-mysite}*.conf
