#!/bin/bash

IMAGE_TAG="ghcr.io/mlr96/archlinux:test"

#sudo setenforce 0
#
#sudo podman build \
#  --cap-add all \
#  -t ${IMAGE_TAG} \
#  .

sudo podman run -it --rm ${IMAGE_TAG} bash
