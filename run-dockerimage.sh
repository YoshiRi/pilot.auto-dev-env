#!/bin/bash
set -e

# --- Usage ---
usage() {
  echo "Usage: $0 <image_name> [--no-agnocast]"
  echo "  <image_name>      : Docker image name"
  echo "  --no-agnocast     : Start autoware_no_agnocast instead of autoware"
  exit 1
}

# --- 引数チェック ---
[ -z "$1" ] && usage
image="$1"
shift

# --- サービス切り替え ---
service="autoware"  # default
while [ $# -gt 0 ]; do
  case "$1" in
    --no-agnocast)
      service="autoware_no_agnocast"
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
  shift
done

# --- CYCLONEDDS_URI 確認 ---
if [ -z "$CYCLONEDDS_URI" ]; then
  echo "❌ Error: CYCLONEDDS_URI is not set."
  echo "Please export: CYCLONEDDS_URI=file:///path/to/cyclonedds.xml"
  exit 1
fi

# --- DDS_PATH 抽出 ---
dds_path=$(echo "$CYCLONEDDS_URI" | sed 's|^file://||')

echo "🚀 Starting Autoware via docker compose"
echo "  Image: ${image}"
echo "  Service: ${service}"
echo "  CYCLONEDDS_URI: ${CYCLONEDDS_URI}"
echo "  DDS_PATH: ${dds_path}"

# --- compose 環境変数設定 ---
export IMAGE_NAME="$image"
export DDS_PATH="$dds_path"

# --- 古いコンテナを消してから起動（必須） ---
docker compose down --remove-orphans

# --- 起動 ---
docker compose run --rm -it "$service"
