#!/bin/bash
set -e

echo "[1/3] Creating workspace..."
mkdir -p ~/autoware/ws/src
cd ~/autoware/ws

echo "[2/3] Importing repositories..."
vcs import src < /home/autoware/ws/debug_tools.repos

echo "[3/3] Installing dependencies..."
rosdep update
rosdep install --from-paths src --ignore-src -r -y
