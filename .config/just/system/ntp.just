# vim: ft=make

ntp: ntpconfig
	#!/usr/bin/env bash
	sudo systemctl enable --now chronyd.service

ntpconfig:
	#!/usr/bin/env bash
	sudo sed 's/^.*OPTIONS.*$/OPTIONS="-F 1"/g' -i /etc/sysconfig/chronyd

	#cat << EOF | sudo tee /etc/chrony.conf
	#server time.cloudflare.com iburst nts
	#server ntppool1.time.nl iburst nts
	#server nts.netnod.se iburst nts
	#server ptbtime1.ptb.de iburst nts

	#minsources 2
	#authselectmode require

	## EF
	#dscp 46

	#driftfile /var/lib/chrony/drift
	#ntsdumpdir /var/lib/chrony

	#leapsectz right/UTC
	#makestep 1.0 3

	#rtconutc
	#rtcsync

	#cmdport 0
	#EOF



