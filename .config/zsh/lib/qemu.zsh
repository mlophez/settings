#!/usr/bin/zsh

function qemu-disk() {
    echo "qemu-img create -f raw <file> <size>"
    echo "qemu-img create -f qcow2 <file> <size>"
}

function qemu-default() {
    qemu-system-x86_64 \
        -k es \
        -enable-kvm \
        -machine q35,accel=kvm \
        -cpu host -smp 2 \
        -m 4G \
        -vga virtio -display gtk,gl=on \
        "$@"
        #-bios /usr/share/qemu/ov \
        #-net nic,model=virtio -net tap,ifname=tap0,script=no,downscript=no,vhost=on \
        #cmd="$cmd -vga virtio -display gtk,gl=on"
}

function qemu-windows() {
    local name="windows10"
    local disk="$HOME/VMs/windows.img"
    local cmd

    [ ! -d "$(dirname $disk)" ] && mkdir -p "$(dirname $disk)" &>/dev/null
    #[ ! -f "$disk" ] && qemu-img create -f qcow2 -o preallocation=falloc,nocow=on $disk $size
    [ ! -f "$disk" ] && qemu-img create -f qcow2 -o nocow=on $disk 100G

    cmd="$cmd qemu-system-x86_64 -k es -enable-kvm -machine q35,accel=kvm -device intel-iommu"
    cmd="$cmd -bios /usr/share/edk2-ovmf/x64/OVMF.fd"
    # CPU
    cmd="$cmd -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time"
    cmd="$cmd -smp 6"
    # MEMORY
    cmd="$cmd -m 8G"
    cmd="$cmd -object memory-backend-memfd,id=mem,size=8G,share=on"
    cmd="$cmd -numa node,memdev=mem"
    # STORAGE
    cmd="$cmd -drive file=$disk,index=0,media=disk,if=virtio,aio=native,cache.direct=on"
    cmd="$cmd -drive file=$HOME/Software/Virt/virtio-win-0.1.185.iso,index=1,media=cdrom"
    # NETWORK
    #cmd="$cmd -net nic -net user,smb=$HOME/Share/VMs"
    cmd="$cmd -netdev user,id=n1 -device virtio-net-pci,netdev=n1"
    # VIDEO
    cmd="$cmd -vga qxl"
    cmd="$cmd -spice unix,addr=/run/user/$UID/$name.qemu.sock,disable-ticketing"
    cmd="$cmd -device virtio-serial-pci"
    cmd="$cmd -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
    cmd="$cmd -chardev spicevmc,id=spicechannel0,name=vdagent"
    # AUDIO
    cmd="$cmd -device intel-hda -device hda-duplex"
    # USB
    cmd="$cmd -device usb-ehci,id=ehci"
    cmd="$cmd -usb -device usb-tablet,bus=ehci.0"

    cmd="$cmd $@"

    eval "$cmd &"

    spicy --gst-disable-segtrap --uri="spice+unix:///run/user/$UID/$name.qemu.sock"
    fg
}
