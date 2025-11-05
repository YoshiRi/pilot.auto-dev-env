#!/bin/bash
set -e

# --- 引数チェック ---
image=${1:?Usage: $0 <image_name>}

# --- CYCLONEDDS_URI が環境にあるか確認 ---
if [ -z "$CYCLONEDDS_URI" ]; then
  echo "❌ Error: CYCLONEDDS_URI environment variable is not set."
  echo "Please run: export CYCLONEDDS_URI=file:///path/to/cyclonedds.xml"
  exit 1
fi

# --- DDS_PATH 抽出 ---
dds_path=$(echo "$CYCLONEDDS_URI" | sed 's|^file://||')

echo "🚀 Starting Autoware via docker compose"
echo "  Image: ${image}"
echo "  CYCLONEDDS_URI: ${CYCLONEDDS_URI}"
echo "  DDS_PATH: ${dds_path}"

# --- compose に渡す環境変数を設定 ---
export IMAGE_NAME="$image"
export DDS_PATH="$dds_path"

# --- docker-compose.yml に設定された autoware サービスを起動 ---
docker compose run --rm -it autoware

