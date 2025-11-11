# 実装ノート / Implementation Notes

## 実装内容

このPRでは、以下の要件に従ってGitHub Actionsワークフローを実装しました。

### 1. ワークフローの作成

**ファイル**: `.github/workflows/run-k6-test.yml`

- `workflow_dispatch`でマニュアル実行可能
- 入力パラメータ:
  - `scenario_file_name`: シナリオファイル名（デフォルト: 空文字）
  - `task_count`: ECS runtaskで実施するタスク数（デフォルト: 1）

### 2. S3アップロード処理

- `scenario/`ディレクトリ以下のファイルを指定
- アップロード先: `s3://hagiwara-k6-test-bucket/k6/scenario.js`
- ファイル名が空の場合はスキップ（条件分岐付き）

### 3. ECS runtask実行

- ecspressoツールを使用（https://github.com/kayac/ecspresso）
- `deploy/`ディレクトリの設定ファイルを使用
- タスク数を指定して実行可能

### 4. デプロイ設定

**ディレクトリ**: `deploy/`

作成されたファイル:
- `config.yaml`: ecspressoの設定ファイル
- `ecs-task-def.json`: ECSタスク定義
- `README.md`: 設定方法の説明

## 使用方法

1. **設定ファイルの更新**:
   - `deploy/config.yaml`: ECSクラスター名、サービス名を設定
   - `deploy/ecs-task-def.json`: ECRリポジトリURI、リソース設定を更新

2. **ワークフローの実行**:
   - GitHubの「Actions」タブを開く
   - 「Run K6 Load Test」ワークフローを選択
   - 「Run workflow」をクリック
   - パラメータを入力:
     - シナリオファイル名（例: `scenario.js`）または空欄
     - タスク数（例: `1`）
   - 実行

## 注意事項

- AWS認証情報（Secrets）が正しく設定されていることを確認してください
- S3バケット（`hagiwara-k6-test-bucket`）へのアクセス権限が必要です
- ECSタスク実行権限が必要です
- `deploy/`ディレクトリの設定ファイルは実際の環境に合わせて更新してください

## Security Summary

CodeQL security analysis completed with no vulnerabilities detected.
