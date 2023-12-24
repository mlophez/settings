# vim: ft=make

modules:
	#!/usr/bin/env bash
	cat << EOF | sudo tee /etc/modprobe.d/30-security.conf
	# https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf
	## Copyright (C) 2012 - 2023 ENCRYPTED SUPPORT LP <adrelanos@whonix.org>
	## See the file COPYING for copying conditions.

	## See the following links for a community discussion and overview regarding the selections
	## https://forums.whonix.org/t/blacklist-more-kernel-modules-to-reduce-attack-surface/7989
	## https://madaidans-insecurities.github.io/guides/linux-hardening.html#kasr-kernel-modules

	## Disable automatic conntrack helper assignment
	## https://phabricator.whonix.org/T486
	options nf_conntrack nf_conntrack_helper=0

	## Disable bluetooth to reduce attack surface due to extended history of security vulnerabilities
	## https://en.wikipedia.org/wiki/Bluetooth#History_of_security_concerns
	#
	## Now replaced by a privacy and security preserving default bluetooth configuration for better usability
	#
	# install bluetooth /bin/false
	# install btusb /bin/false

	## Disable thunderbolt and firewire modules to prevent some DMA attacks
	install thunderbolt /bin/false
	install firewire-core /bin/false
	install firewire_core /bin/false
	install firewire-ohci /bin/false
	install firewire_ohci /bin/false
	install firewire_sbp2 /bin/false
	install firewire-sbp2 /bin/false
	install ohci1394 /bin/false
	install sbp2 /bin/false
	install dv1394 /bin/false
	install raw1394 /bin/false
	install video1394 /bin/false

	## Disable CPU MSRs as they can be abused to write to arbitrary memory.
	## https://security.stackexchange.com/questions/119712/methods-root-can-use-to-elevate-itself-to-kernel-mode
	install msr /bin/false

	## Disables unneeded network protocols that will likely not be used as these may have unknown vulnerabilties.
	## Credit to Tails (https://tails.boum.org/blueprint/blacklist_modules/) for some of these.
	## > Debian ships a long list of modules for wide support of devices, filesystems, protocols. Some of these modules have a pretty bad security track record, and some of those are simply not used by most of our users.
	## > Other distributions like Ubuntu[1] and Fedora[2] already ship a blacklist for various network protocols which aren't much in use by users and have a poor security track record.
	install dccp /bin/false
	install sctp /bin/false
	install rds /bin/false
	install tipc /bin/false
	install n-hdlc /bin/false
	install ax25 /bin/false
	install netrom /bin/false
	install x25 /bin/false
	install rose /bin/false
	install decnet /bin/false
	install econet /bin/false
	install af_802154 /bin/false
	install ipx /bin/false
	install appletalk /bin/false
	install psnap /bin/false
	install p8023 /bin/false
	install p8022 /bin/false
	install can /bin/false
	install atm /bin/false

	## Disable uncommon file systems to reduce attack surface
	## HFS and HFS+ are legacy Apple filesystems that may be required depending on the EFI parition format
	install cramfs /bin/false
	install freevxfs /bin/false
	install jffs2 /bin/false
	install hfs /bin/false
	install hfsplus /bin/false
	install udf /bin/false

	## Disable uncommon network file systems to reduce attack surface
	install cifs /bin/false
	install nfs /bin/false
	install nfsv3 /bin/false
	install nfsv4 /bin/false
	install ksmbd /bin/false
	install gfs2 /bin/false

	## Disables the vivid kernel module as it's only required for testing and has been the cause of multiple vulnerabilities
	## https://forums.whonix.org/t/kernel-recompilation-for-better-hardening/7598/233
	## https://www.openwall.com/lists/oss-security/2019/11/02/1
	## https://github.com/a13xp0p0v/kconfig-hardened-check/commit/981bd163fa19fccbc5ce5d4182e639d67e484475
	install vivid /bin/false

	## Disable Intel Management Engine (ME) interface with the OS
	## https://www.kernel.org/doc/html/latest/driver-api/mei/mei.html
	install mei /bin/false
	install mei-me /bin/false

	## Blacklist automatic loading of the Atheros 5K RF MACs madwifi driver
	## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist-ath_pci.conf?h=ubuntu/disco
	blacklist ath_pci

	## Blacklist automatic loading of miscellaneous modules
	## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist.conf?h=ubuntu/disco
	blacklist evbug
	blacklist usbmouse
	blacklist usbkbd
	blacklist eepro100
	blacklist de4x5
	blacklist eth1394
	blacklist snd_intel8x0m
	blacklist snd_aw2
	blacklist prism54
	blacklist bcm43xx
	blacklist garmin_gps
	blacklist asus_acpi
	blacklist snd_pcsp
	blacklist pcspkr
	blacklist amd76x_edac

	## Blacklist automatic loading of framebuffer drivers
	## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist-framebuffer.conf?h=ubuntu/disco
	blacklist aty128fb
	blacklist atyfb
	blacklist radeonfb
	blacklist cirrusfb
	blacklist cyber2000fb
	blacklist cyblafb
	blacklist gx1fb
	blacklist hgafb
	blacklist i810fb
	blacklist intelfb
	blacklist kyrofb
	blacklist lxfb
	blacklist matroxfb_bases
	blacklist neofb
	blacklist nvidiafb
	blacklist pm2fb
	blacklist rivafb
	blacklist s1d13xxxfb
	blacklist savagefb
	blacklist sisfb
	blacklist sstfb
	blacklist tdfxfb
	blacklist tridentfb
	blacklist vesafb
	blacklist vfb
	blacklist viafb
	blacklist vt8623fb
	blacklist udlfb

	## Disable CD-ROM devices
	## https://nvd.nist.gov/vuln/detail/CVE-2018-11506
	## https://forums.whonix.org/t/blacklist-more-kernel-modules-to-reduce-attack-surface/7989/31
	#install cdrom /bin/false
	#install sr_mod /bin/false
	blacklist cdrom
	blacklist sr_mod
	EOF
