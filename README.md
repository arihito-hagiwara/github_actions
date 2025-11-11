# github_actions

This repository contains a Docker image for k6 load testing with AWS S3 integration and GitHub Actions workflows for building and running load tests.

## GitHub Actions Workflows

This repository includes two GitHub Actions workflows:

1. **Build and Push Docker Image to AWS ECR** - Automatically builds and pushes the k6 Docker image
2. **Run K6 Load Test** - Manually triggers k6 load tests with ECS tasks

### 1. Build and Push Docker Image to AWS ECR

A GitHub Actions workflow is configured to automatically build and push the Docker image to AWS ECR.

### Workflow Triggers

The workflow runs when:
- Changes are pushed to the `main` branch that affect:
  - `Dockerfile`
  - `entrypoint.sh`
- Manual workflow dispatch (can be triggered manually from the GitHub Actions tab)

### Required Secrets

To use this workflow, configure the following secrets in your GitHub repository settings (Settings → Secrets and variables → Actions):

- `AWS_ACCESS_KEY_ID`: AWS access key ID with ECR push permissions
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key
- `AWS_REGION`: AWS region where your ECR repository is located (e.g., `us-east-1`)
- `ECR_REPOSITORY_NAME`: Name of your ECR repository

### Manual Execution

To manually trigger the workflow:
1. Go to the "Actions" tab in your GitHub repository
2. Select "Build and Push Docker Image to AWS ECR" workflow
3. Click "Run workflow"
4. Select the branch and click "Run workflow"

### Workflow Details

The workflow performs the following steps:
1. Checks out the code
2. Configures AWS credentials
3. Logs in to Amazon ECR
4. Builds the Docker image
5. Tags the image with both the commit SHA and `latest`
6. Pushes both tags to ECR

### 2. Run K6 Load Test

This workflow allows you to manually trigger k6 load tests using AWS ECS tasks via ecspresso.

#### Workflow Triggers

This workflow can only be triggered manually using workflow_dispatch.

#### Input Parameters

- `scenario_file_name` (optional): Name of the scenario file from the `scenario/` directory (e.g., `scenario.js`). If left empty, the S3 upload step is skipped.
  - Default: empty string
- `task_count` (optional): Number of ECS tasks to run concurrently for the load test
  - Default: `1`

#### Manual Execution

To manually trigger the workflow:
1. Go to the "Actions" tab in your GitHub repository
2. Select "Run K6 Load Test" workflow
3. Click "Run workflow"
4. Fill in the input parameters:
   - Enter scenario file name (or leave empty to skip S3 upload)
   - Enter task count (default is 1)
5. Click "Run workflow"

#### Workflow Details

The workflow performs the following steps:
1. Checks out the code
2. Configures AWS credentials
3. **Uploads scenario file to S3** (conditional):
   - If `scenario_file_name` is provided, uploads the file from `scenario/` directory to `s3://hagiwara-k6-test-bucket/k6/scenario.js`
   - Skips this step if `scenario_file_name` is empty
4. Installs ecspresso tool
5. Runs ECS task using ecspresso with the specified task count

#### Configuration

Before using this workflow, you need to:

1. Configure the ecspresso settings in the `deploy/` directory:
   - Update `deploy/config.yaml` with your ECS cluster and service information
   - Update `deploy/ecs-task-def.json` with your task definition

2. Ensure AWS credentials have permissions for:
   - S3 upload to `hagiwara-k6-test-bucket`
   - ECS task execution
   - ECR image pull

See the `deploy/README.md` for detailed configuration instructions.