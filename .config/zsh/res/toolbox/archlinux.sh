#!/bin/bash

# buildah unshare
buildah bud -f archlinux.dockerfile -t archlinux-toolbox:latest .