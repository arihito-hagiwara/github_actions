# github_actions

This repository contains a Docker image for k6 load testing with AWS S3 integration.

## GitHub Actions Workflow

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