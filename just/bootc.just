image := "localhost/workstation"

# Build local bootc image from Containerfile (tag = YYYYMMDD + latest)
bootc-build:
  #!/usr/bin/env bash
  set -euo pipefail
  tag="$(date +%Y%m%d)"
  sudo podman build --pull=newer \
    -t {{image}}:"${tag}" \
    -t {{image}}:latest \
    -f Containerfile .

# Rebase running system to the local image (first-time switch)
bootc-switch:
  sudo bootc switch --transport containers-storage {{image}}:latest

# Show current bootc deployment status
bootc-status:
  sudo bootc status

# Rollback to previous deployment
bootc-rollback:
  sudo bootc rollback

# List local images built for this workstation
bootc-images:
  sudo podman images {{image}}

# Prune old local images (keep latest + today's date tag)
bootc-prune:
  #!/usr/bin/env bash
  set -euo pipefail
  keep="$(date +%Y%m%d)"
  sudo podman images --format '{{{{.Repository}}:{{{{.Tag}}' {{image}} \
    | grep -v -E ":(latest|${keep})$" \
    | xargs -r -n1 sudo podman rmi -f

# Rebuild local image and apply with bootc upgrade
upgrade-system: bootc-build
  sudo bootc upgrade
