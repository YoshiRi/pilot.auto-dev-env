# Pilot Auto Dev Environment (Minimal Template)

軽量なDocker + Compose構成でAutoware解析環境を起動するための雛形です。


```bash
# build
./build-image.sh <base-image> (<target-image>)

# run (with GPU support)
./run-dockerimage.sh <your-username>
```


Following comments are now invalid and should be ignored.

## 🚀 セットアップ手順

```bash
git clone https://github.com/<your-username>/pilot.auto-dev-env.git
cd pilot.auto-dev-env
docker compose up --build
```

## 🧩 構成概要
ファイル	役割
Dockerfile	ROS2環境とdebug_toolsを含むベースイメージ
docker-compose.yml	GPU/agnocast対応の起動設定
repos/debug_tools.repos	vcs import定義
scripts/	ツール導入・Autoware起動などの補助スクリプト

## 🛠️ 拡張案
.devcontainer/ を追加してVSCode統合

repos/perception.repos など他のAutowareモジュールを追加

install_tools.sh に解析ツール（Foxglove等）を追加

```
=== 9. Git初期化とコミット ===

git init
git add .
git commit -m "Initial commit: minimal Pilot Auto dev environment"
git branch -M main

=== 10. push ===
git push -u origin main

```
---

💡 **ポイント**
- GitHubは`.`（ドット）を含むリポジトリ名も許可しているので問題ありません。  
- clone時は `git clone https://github.com/<your-username>/pilot.auto-dev-env.git` のようにピリオド入りでOK。  
- VSCodeなどでも問題なく開けます。