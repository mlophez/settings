# ==========================================================================
# LEGACY: flujo bootc/ublue (Bluefin GTS) previo a la migración a Fedora KDE
# mutable. Se conserva solo como referencia. NO se importa desde el Justfile
# raíz: para reactivarlo hay que añadir `import 'legacy/system.just'` y usar
# `legacy/Containerfile`. Ver docs/install.md para el flujo actual.
# ==========================================================================

# Rebuild local image and apply with bootc upgrade
[group('Legacy')]
upgrade: build
  sudo bootc upgrade

# Build local bootc image from Containerfile (tag = YYYYMMDD + latest)
[group('Legacy')]
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
    -f legacy/Containerfile .

# Rebase running system to the local image (first-time switch)
[group('Legacy')]
switch:
  sudo bootc switch --transport containers-storage {{image}}:latest

# Show current bootc deployment status
[group('Legacy')]
status:
  sudo bootc status

# Rollback to previous deployment
[group('Legacy')]
rollback:
  sudo bootc rollback

# List local images built for this workstation
[group('Legacy')]
list-images:
  sudo podman images {{image}}

# Prune old local images (keep latest + today's date tag)
[group('Legacy')]
prune-images:
  #!/usr/bin/env bash
  set -euo pipefail
  keep="$(date +%Y%m%d)"
  sudo podman images --format '{{{{.Repository}}:{{{{.Tag}}' {{image}} \
    | grep -v -E ":(latest|${keep})$" \
    | xargs -r -n1 sudo podman rmi -f
