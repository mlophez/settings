# Rebuild local image and apply with bootc upgrade
[group('System')]
upgrade: build
  sudo bootc upgrade

# Build local bootc image from Containerfile (tag = YYYYMMDD + latest)
[group('System')]
build:
  #!/usr/bin/env bash
  set -euo pipefail
  tag="$(date +%Y%m%d)"
  cpus=$(( $(nproc) / 2 ))
  sudo podman build --pull=newer \
    --squash \
    --retry=5 --retry-delay=10s \
    --cpu-shares=2 \
    -t {{image}}:"${tag}" \
    -t {{image}}:latest \
    -f Containerfile .

# Rebase running system to the local image (first-time switch)
[group('System')]
switch:
  sudo bootc switch --transport containers-storage {{image}}:latest

# Show current bootc deployment status
[group('System')]
status:
  sudo bootc status

# Rollback to previous deployment
[group('System')]
rollback:
  sudo bootc rollback

# List local images built for this workstation
[group('System')]
list-images:
  sudo podman images {{image}}

# Prune old local images (keep latest + today's date tag)
[group('System')]
prune-images:
  #!/usr/bin/env bash
  set -euo pipefail
  keep="$(date +%Y%m%d)"
  sudo podman images --format '{{{{.Repository}}:{{{{.Tag}}' {{image}} \
    | grep -v -E ":(latest|${keep})$" \
    | xargs -r -n1 sudo podman rmi -f
