# github_actions

このリポジトリには、AWS S3統合を備えたk6負荷テスト用のDockerイメージと、ビルドおよび負荷テスト実行のためのGitHub Actionsワークフローが含まれています。

## GitHub Actionsワークフロー

このリポジトリには2つのGitHub Actionsワークフローが含まれています：

1. **DockerイメージのビルドとAWS ECRへのプッシュ** - k6 Dockerイメージを自動的にビルドしてプッシュします
2. **K6負荷テストの実行** - ECSタスクを使用してk6負荷テストを手動でトリガーします

### 1. DockerイメージのビルドとAWS ECRへのプッシュ

DockerイメージをAWS ECRに自動的にビルドしてプッシュするGitHub Actionsワークフローが設定されています。

### ワークフローのトリガー

ワークフローは以下の場合に実行されます：
- `main`ブランチに以下のファイルに影響を与える変更がプッシュされた場合：
  - `Dockerfile`
  - `entrypoint.sh`
- 手動ワークフローディスパッチ（GitHub Actionsタブから手動でトリガー可能）

### 必要なシークレット

このワークフローを使用するには、GitHubリポジトリの設定（Settings → Secrets and variables → Actions）で以下のシークレットを設定してください：

- `AWS_ACCESS_KEY_ID`: ECRプッシュ権限を持つAWSアクセスキーID
- `AWS_SECRET_ACCESS_KEY`: AWSシークレットアクセスキー
- `AWS_REGION`: ECRリポジトリが配置されているAWSリージョン（例：`us-east-1`）
- `ECR_REPOSITORY_NAME`: ECRリポジトリの名前

### 手動実行

ワークフローを手動でトリガーするには：
1. GitHubリポジトリの「Actions」タブに移動します
2. 「Build and Push Docker Image to AWS ECR」ワークフローを選択します
3. 「Run workflow」をクリックします
4. ブランチを選択して「Run workflow」をクリックします

### ワークフローの詳細

ワークフローは以下のステップを実行します：
1. コードをチェックアウトします
2. AWS認証情報を設定します
3. Amazon ECRにログインします
4. Dockerイメージをビルドします
5. コミットSHAと`latest`の両方でイメージにタグを付けます
6. 両方のタグをECRにプッシュします

### 2. K6負荷テストの実行

このワークフローでは、ecspressoを使用してAWS ECSタスクでk6負荷テストを手動でトリガーできます。

#### ワークフローのトリガー

このワークフローはworkflow_dispatchを使用して手動でのみトリガーできます。

#### 入力パラメータ

- `scenario_file_name`（オプション）：`scenario/`ディレクトリからのシナリオファイル名（例：`scenario.js`）。空のままにするとS3アップロードステップはスキップされます。
  - デフォルト：空文字列
- `task_count`（オプション）：負荷テストのために同時に実行するECSタスクの数
  - デフォルト：`1`

#### 手動実行

ワークフローを手動でトリガーするには：
1. GitHubリポジトリの「Actions」タブに移動します
2. 「Run K6 Load Test」ワークフローを選択します
3. 「Run workflow」をクリックします
4. 入力パラメータを入力します：
   - シナリオファイル名を入力します（またはS3アップロードをスキップするには空のままにします）
   - タスク数を入力します（デフォルトは1）
5. 「Run workflow」をクリックします

#### ワークフローの詳細

ワークフローは以下のステップを実行します：
1. コードをチェックアウトします
2. AWS認証情報を設定します
3. **シナリオファイルをS3にアップロード**（条件付き）：
   - `scenario_file_name`が指定されている場合、`scenario/`ディレクトリからファイルを`s3://hagiwara-k6-test-bucket/k6/scenario.js`にアップロードします
   - `scenario_file_name`が空の場合、このステップをスキップします
4. ecspressoツールをインストールします
5. 指定されたタスク数でecspressoを使用してECSタスクを実行します

#### 設定

このワークフローを使用する前に、以下を行う必要があります：

1. `deploy/`ディレクトリでecspresso設定を構成します：
   - ECSクラスターとサービス情報で`deploy/config.yaml`を更新します
   - タスク定義で`deploy/ecs-task-def.json`を更新します

2. AWS認証情報が以下の権限を持っていることを確認します：
   - `hagiwara-k6-test-bucket`へのS3アップロード
   - ECSタスクの実行
   - ECRイメージのプル

詳細な設定手順については、`deploy/README.md`を参照してください。