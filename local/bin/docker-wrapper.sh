#!/bin/bash

# A simple wrapper to support container in macos and podman in linux

container_wrapper() {
    # macOS - use container
    container system status &>/dev/null || container system start
    # if is docker login change by container registry login
    [[ "$1" == "container" ]] && shift
    [[ "$1" == "containers" ]] && shift

    [[ "$1" == "login" ]] && shift && set -- "registry" "login" "$@"
    [[ "$1" == "push" ]]  && shift && set -- "image" "push" "$@"
    [[ "$1" == "pull" ]]  && shift && set -- "image" "pull" "$@"
    [[ "$1" == "tag" ]]  && shift && set -- "image" "tag" "$@"
    [[ "$1" == "ps" ]] && shift && set -- "ls" "$@"

    # Always show all containers
    [[ "$1" == "ls" ]] && shift && set -- "ls" "-a" "$@"

    if [[ "$1" == "build" ]]; then
      shift
      # If no -f is provided and Containerfile exists, use it
      if [[ -e "Containerfile" && " $* " != *" -f "* ]]; then
        set -- "-f" "Containerfile" "$@"
      fi
      set -- "build" "-c" "5" "-m" "4096MB" "$@"
    fi

    # Erase network_mode=host
    if [[ "$1" == "run" ]]; then
      shift
      args=()
      while [[ $# -gt 0 ]]; do
        if [[ "$1" == "--network=host" || "$1" == "--network host" ]]; then
          shift
        else
          args+=("$1")
          shift
        fi
      done
      set -- "run" "${args[@]}"
      echo "Warning: --network=host is not supported in macOS and has been removed."
    fi

    container "$@"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    container_wrapper "$@"
else
    podman "$@"
fi
