# Deploy Configuration for ecspresso

This directory contains configuration files for running ECS tasks using [ecspresso](https://github.com/kayac/ecspresso).

## Files

- `config.yaml`: ecspresso configuration file
- `ecs-task-def.json`: ECS task definition

## Setup Instructions

1. Update `config.yaml` with your actual:
   - AWS region
   - ECS cluster name
   - ECS service name

2. Update `ecs-task-def.json` with your actual:
   - ECR repository URI (replace `<ECR_REPOSITORY_URI>`)
   - CPU and memory requirements
   - Log group configuration
   - Environment variables (including DB_INFO if needed)

3. Ensure you have the required AWS IAM permissions for:
   - ECS task execution
   - CloudWatch Logs access
   - ECR image pull

## Usage

The workflow automatically runs ecspresso with the specified task count:

```bash
ecspresso run --config config.yaml --tasks <TASK_COUNT>
```
