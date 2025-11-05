#!/bin/bash
set -e

# --- 引数チェック ---
source_image=${1:?source_image is not specified}
target_image=${2:-"$source_image"}  # ← target未指定ならsourceと同じにする（自動replaceモード）

# --- source_image のユーザを取得 ---
user=$(docker inspect --type=image "$source_image" -f '{{ .Config.User }}' 2>/dev/null || true)
if [ -z "$user" ]; then
  echo "⚠️ Warning: user not found in base image. Defaulting to 'autoware'"
  user="autoware"
fi

echo "🧩 Using user=$user"
echo "🛠️  Building from base: $source_image"
echo "🎯 Target image: $target_image"

# --- 一時タグ（自動replace時は安全に上書きするために）---
tmp_tag="${target_image}_tmp_$(date +%s)"

# --- ビルド ---
docker build \
  -t "$tmp_tag" \
  --build-arg base="$source_image" \
  --build-arg user="$user" \
  .

# --- targetがsourceと同じならreplaceモード ---
if [ "$target_image" = "$source_image" ]; then
  echo "🔁 Replace mode: removing old image $source_image"
  docker rmi -f "$source_image" || true
fi

# --- rename & cleanup ---
docker tag "$tmp_tag" "$target_image"
docker rmi -f "$tmp_tag" || true

echo "🧹 Cleaning up dangling images..."
docker image prune -f >/dev/null
docker builder prune -f >/dev/null

echo "✅ Done! New image: $target_image"
docker images | grep "$target_image"
