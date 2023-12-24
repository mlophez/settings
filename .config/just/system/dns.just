# vim: ft=make

dns:
	#!/usr/bin/env bash
	sudo sed 's/^.*DNSSEC.*$/DNSSEC=yes/g' -i /etc/systemd/resolved.conf
	sudo systemctl enable --now systemd-resolved


