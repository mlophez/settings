# vim: ft=make

NetworkManager:
	#!/usr/bin/env bash
	cat << EOF | sudo tee /etc/NetworkManager/conf.d/00-macrandomize.conf &>/dev/null
	[device]
	wifi.scan-rand-mac-address=yes

	[connection]
	wifi.cloned-mac-address=random
	ethernet.cloned-mac-address=random
	EOF

Network:
	sudo hostnamectl hostname "localhost"

Flatpak:
	flatpak --user override --nofilesystem='home' --nofilesystem='host' --nofilesystem='host-etc' --nofilesystem='host-os'
	flatpak --user override --nosocket='x11'
	flatpak --user override --nodevice='all'

iptables:
	#!/usr/bin/env bash
	sudo mkdir -p /etc/iptables/ &>/dev/null

	cat << EOF | sudo tee /etc/iptables/iptables.rules
	*filter
	:INPUT DROP [0:0]
	:FORWARD DROP [0:0]
	:OUTPUT ACCEPT [0:0]
	-A INPUT -p icmp -j ACCEPT
	-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
	-A INPUT -i lo -j ACCEPT
	-A INPUT -p tcp -j REJECT --reject-with tcp-reset
	-A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
	-A INPUT -j REJECT --reject-with icmp-proto-unreachable
	COMMIT
	EOF

	cat << EOF | sudo tee /etc/iptables/ip6tables.rules
	*filter
	:INPUT DROP [0:0]
	:FORWARD DROP [0:0]
	:OUTPUT DROP [0:0]
	COMMIT
	EOF

	sudo systemctl enable --now iptables.service
	sudo systemctl enable --now ip6tables.service

firewalld:
	sudo systemctl enable --now firewalld
	sudo firewall-cmd --set-default-zone=block
	sudo firewall-cmd --lockdown-on
	sudo firewall-cmd --reload

umask:
	#!/usr/bin/env bash
	sudo sed 's/^UMASK.*$/UMASK 077/g' -i /etc/login.defs
	echo "umask 077" | sudo tee /etc/profile.d/umask.sh

systemd:
	#!/usr/bin/env bash
	# sudo systemd-analyze security
	# sudo systemctl list-units --type=service --state=active
	# sudo systemctl list-units --type=service --state=running
	# systemctl list-dependencies systemd-sysusers.service --all --reverse
	for service in $(sudo systemctl list-unit-files --type=service --state=enabled | awk '{print $1}'); do
		echo $service
	done


