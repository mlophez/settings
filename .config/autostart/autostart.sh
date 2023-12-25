#!/usr/bin/env bash

distrobox-start() {
  distrobox enter ${1} -- echo
}

if type distrobox &>/dev/null; then
  #for name in $(distrobox list --no-color | awk -F'|' '{print $2}' | grep -v "NAME" | tr '\n' ' '); do
  for name in $(distrobox list --no-color | awk -F'|' '{print $2}' | grep -v "NAME" ); do
    distrobox-start ${name} &
  done
fi

wait
exit 0
