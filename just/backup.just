backup:
  #!/bin/bash
  distrobox-host-exec sudo bash -c << 'EOF'
    DISK=$(blkid -U 77a01e45-e966-48f0-90c3-73589b397528)
    MOUNTPOINT=/mnt/backup

    sudo mkdir -p $MOUNTPOINT
    [[ mountpoint -q $MOUNTPOINT ]] || sudo mount $DISK $MOUNTPOINT

    ls -lah $MOUNTPOINT/
    umount $MOUNTPOINT
  EOF
