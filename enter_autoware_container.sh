#!/usr/bin/env bash

set -e

echo "Select autoware container to enter:"

CONTAINER=$(docker ps --format '{{.Names}}' | grep autoware-run | fzf --prompt="> ")

if [ -z "$CONTAINER" ]; then
  echo "No container selected. Exit."
  exit 1
fi

echo "Entering: $CONTAINER"

docker exec -it "$CONTAINER" bash -c "source install/setup.bash && exec bash"
