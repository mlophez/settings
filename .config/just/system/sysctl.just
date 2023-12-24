# vim: ft=make

sysctl:
	#!/usr/bin/env bash
	cat << EOF | sudo tee /etc/sysctl.d/99-sysctl.conf
	### GENERAL ###
	vm.swappiness=0

	### NETWORK ###
	net.ipv4.ping_group_range = 0   2147483647
	## Increasing the size of the receive queue.
	net.core.netdev_max_backlog = 16384

	# Increase the maximum connections
	net.core.somaxconn = 8192

	# Increase the memory dedicated to the network interfaces
	net.core.rmem_default = 1048576
	net.core.rmem_max = 16777216
	net.core.wmem_default = 1048576
	net.core.wmem_max = 16777216
	net.core.optmem_max = 65536
	net.ipv4.tcp_rmem = 4096 1048576 6291456
	net.ipv4.tcp_wmem = 4096 65536 16777216
	net.ipv4.udp_rmem_min = 8192
	net.ipv4.udp_wmem_min = 8192

	# Enable TCP Fast Open
	net.ipv4.tcp_fastopen = 3

	# Tweak the pending connection handling
	net.ipv4.tcp_max_syn_backlog = 8192
	net.ipv4.tcp_max_tw_buckets = 2000000
	net.ipv4.tcp_tw_reuse = 1
	net.ipv4.tcp_fin_timeout = 10
	net.ipv4.tcp_slow_start_after_idle = 0

	# Change TCP keepalive parameters
	net.ipv4.tcp_keepalive_time = 60
	net.ipv4.tcp_keepalive_intvl = 10
	net.ipv4.tcp_keepalive_probes = 6

	# Enable MTU probing
	net.ipv4.tcp_mtu_probing = 1

	### PODMAN ###
	user.max_user_namespaces=31152

	### HARDENING ###
	# https://madaidans-insecurities.github.io/guides/linux-hardening.html
	# https://privsec.dev/posts/linux/desktop-linux-hardening
	# https://github.com/Kicksecure/security-misc/tree/master/etc/
	kernel.kptr_restrict=2
	kernel.dmesg_restrict=1
	kernel.printk=3 3 3 3
	kernel.unprivileged_bpf_disabled=1
	kernel.kexec_load_disabled=1
	kernel.sysrq=4
	kernel.yama.ptrace_scope=2
	# kernel.unprivileged_userns_clone=0
	# user.max_user_namespaces=0
	net.core.bpf_jit_harden=2
	net.ipv4.tcp_syncookies=1
	net.ipv4.tcp_rfc1337=1
	net.ipv4.conf.all.rp_filter=1
	net.ipv4.conf.default.rp_filter=1
	net.ipv4.conf.all.accept_redirects=0
	net.ipv4.conf.default.accept_redirects=0
	net.ipv4.conf.all.secure_redirects=0
	net.ipv4.conf.default.secure_redirects=0
	net.ipv4.conf.all.send_redirects=0
	net.ipv4.conf.default.send_redirects=0
	net.ipv4.icmp_echo_ignore_all=1
	net.ipv4.conf.all.accept_source_route=0
	net.ipv4.conf.default.accept_source_route=0
	net.ipv4.tcp_sack=0
	net.ipv4.tcp_dsack=0
	net.ipv4.tcp_fack=0
	net.ipv6.conf.all.disable_ipv6 = 1
	net.ipv6.conf.all.accept_redirects=0
	net.ipv6.conf.default.accept_redirects=0
	net.ipv6.conf.all.accept_source_route=0
	net.ipv6.conf.default.accept_source_route=0
	net.ipv6.conf.all.accept_ra=0
	net.ipv6.conf.default.accept_ra=0
	dev.tty.ldisc_autoload=0
	vm.unprivileged_userfaultfd=0
	vm.mmap_rnd_bits=32
	vm.mmap_rnd_compat_bits=16
	fs.protected_symlinks=1
	fs.protected_hardlinks=1
	fs.protected_fifos=2
	fs.protected_regular=2
	EOF
	sudo sysctl -p


