#!/usr/bin/env bash

if type distrobox &>/dev/null; then
  #for name in $(distrobox list --no-color | awk -F'|' '{print $2}' | grep -v "NAME" | tr '\n' ' '); do
  for name in $(distrobox list --no-color | awk -F'|' '{print $2}' | grep -v "NAME" ); do
    distrobox enter ${name} -- echo
  done
fi
