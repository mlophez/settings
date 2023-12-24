# vim: ft=make

boot:
	#!/usr/bin/env bash
	ftmp=/tmp/rpm-ostree-kargs.txt
	cat << EOF > ${ftmp}
	# CPU mitigations
	spectre_v2=on
	spec_store_bypass_disable=on
	l1tf=full,force
	mds=full,nosmt
	tsx=off
	tsx_async_abort=full,nosmt
	kvm.nx_huge_pages=force
	nosmt=force
	l1d_flush=on
	mmio_stale_data=full,nosmt
	# Kernel
	slab_nomerge
	init_on_alloc=1
	init_on_free=1
	pti=on
	vsyscall=none
	page_alloc.shuffle=1
	randomize_kstack_offset=on
	extra_latent_entropy
	debugfs=off
	oops=panic
	quiet
	loglevel=0
	# Entropy generation
	random.trust_cpu=off
	random.trust_bootloader=off
	# DMA mitigations
	intel_iommu=on
	amd_iommu=force_isolation
	efi=disable_early_pci_dma
	iommu=force
	iommu.passthrough=0
	iommu.strict=1
	EOF
	opts=$(cat $ftmp | grep -v "#" | tr '\n' ' ')
	sudo rpm-ostree kargs --append-if-missing="$opts"
	sudo rpm-ostree kargs
