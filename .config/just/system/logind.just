# vim: ft=make

logind:
	#!/usr/bin/env bash
	[ ! -e /etc/systemd/logind.conf ] && sudo cp /etc/systemd/logind.conf /etc/systemd/logind.backup.conf
	sudo sed 's/^.*KillUserProcesses *=.*$/KillUserProcesses=yes/g' -i /etc/systemd/logind.conf
	sudo sed 's/^.*HandlePowerKey *=.*$/HandlePowerKey=suspend/g' -i /etc/systemd/logind.conf
	sudo sed 's/^.*HandleSuspendKey *=.*$/HandleSuspendKey=suspend/g' -i /etc/systemd/logind.conf
	sudo sed 's/^.*HandleHibernateKey *=.*$/HandleHibernateKey=hibernate/g' -i /etc/systemd/logind.conf
	sudo sed 's/^.*HandleLidSwitch *=.*$/HandleLidSwitch=ignore/g' -i /etc/systemd/logind.conf
	sudo sed 's/^.*HandleLidSwitchExternalPower *=.*$/HandleLidSwitchExternalPower=ignore/g' -i /etc/systemd/logind.conf
	sudo sed 's/^.*HandleLidSwitchDocked *=.*$/HandleLidSwitchDocked=ignore/g' -i /etc/systemd/logind.conf

