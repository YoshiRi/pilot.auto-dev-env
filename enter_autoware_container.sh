#!/usr/bin/env bash

set -euo pipefail

echo "Select autoware container to enter:"

CONTAINER_CANDIDATES=$(docker ps --format '{{.Names}}\t{{.Image}}' \
  | awk -F'\t' 'tolower($1) ~ /autoware/ || tolower($2) ~ /autoware/ { print }')

if [ -z "$CONTAINER_CANDIDATES" ]; then
  echo "No running Autoware container found."
  exit 1
fi

SELECTED=$(printf '%s\n' "$CONTAINER_CANDIDATES" | fzf --prompt="> ")
CONTAINER=$(printf '%s\n' "$SELECTED" | cut -f1)

if [ -z "$CONTAINER" ]; then
  echo "No container selected. Exit."
  exit 1
fi

echo "Entering: $CONTAINER"

docker exec -it "$CONTAINER" bash -c "source install/setup.bash && exec bash"
