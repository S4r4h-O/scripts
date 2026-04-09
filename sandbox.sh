#!/bin/bash

PRIVILEGED=false
IMAGE="fedora:latest"

for arg in "$@"; do
  case "$arg" in
  --privileged)
    PRIVILEGED=true
    ;;
  *)
    IMAGE="$arg"
    ;;
  esac
done

_run() {
  local -a extra=()
  # Same as:
  # if [[ "$PRIVILEGED" == true ]]; then
  #   extra=(--privileged)
  # fi
  $PRIVILEGED && extra=(--privileged)

  podman run \
    --rm \
    -it \
    "${extra[@]}" \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    --pids-limit 256 \
    --memory 512m \
    "$IMAGE" \
    bash
}

_run
