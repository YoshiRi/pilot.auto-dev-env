#!/bin/bash
set -e

echo "[*] Installing additional utilities..."
apt-get update && apt-get install -y \
  vim htop tmux \
  && rm -rf /var/lib/apt/lists/*

pip install matplotlib numpy
