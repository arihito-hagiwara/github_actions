#!/bin/sh

# 1. 失敗したら即座に終了する
set -e

echo "Entry-point script started..."

# aws s3 cp コマンドでシナリオをダウンロード
aws s3 cp s3://hagiwara-k6-test-bucket/k6/scenario.js scenario.js

# (オプション) ダウンロードが成功したか簡易的に確認
if [ ! -f scenario.js ]; then
  echo "Error: scenario.js file download failed."
  exit 1
fi

echo "Config file downloaded successfully."

# -----------------------------------------------------------------
# 3. メインプロセスの実行 (exec を忘れずに)
# -----------------------------------------------------------------
# DockerfileのCMDで指定されたコマンド (例: ["my-server", "--config", "/app/config/settings.yml"])
# が "$@" に入ります。
echo "Executing main command: $@"
exec "$@"
