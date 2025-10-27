#!/bin/bash

# A simple wrapper to support container in macos and podman in linux

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use Docker
    # if is docker login change by container registry login
    [[ "$1" == "login" ]] && shift && set -- "registry" "login" "$@"
    [[ "$1" == "push" ]]  && shift && set -- "image" "push" "$@"
    [[ "$1" == "pull" ]]  && shift && set -- "image" "pull" "$@"
    container "$@"
else
    # Linux - use Podman
    podman "$@"
fi
