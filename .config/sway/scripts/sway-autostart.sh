#!/bin/bash

type distrobox &>/dev/null && \
  distrobox enter archlinux-test -- echo
