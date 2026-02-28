# infra-mini-gallery-app

Infrastructure-as-Code (IaC) repository for the **Mini Gallery App** backend on AWS, using Terraform.

This repo provisions the backend infrastructure (API Gateway + Lambda + S3 + DynamoDB + monitoring, plus image moderation/quarantine components) and is designed to be deployed via **GitHub Actions using AWS OIDC** (no long-lived AWS keys).

---

## What this repo deploys

At a high level, the Terraform code in this repository deploys:

- **File uploader backend**
  - S3 bucket(s) for uploads (+ access logs)
  - DynamoDB table for file metadata
  - Lambda functions (upload processing, listing files, etc.)
  - API Gateway (custom domain + certificate)
  - WAF (API protection)
  - Route53 record(s)
  - SNS topics/subscriptions for alerts
  - KMS keys/aliases for encryption
  - CloudWatch dashboards/alarms for monitoring

- **Image moderation / quarantine**
  - Additional Lambda functions for scanning/moderation workflows
  - Quarantine bucket + access logs
  - EventBridge scheduled rules
  - SNS alerts
  - KMS keys/aliases

---

## Prerequisites

### Local usage
- Terraform `>= 1.3`
- AWS credentials available locally (e.g., via `aws configure` / SSO)
- Access to the Terraform backend:
  - S3 state bucket
  - DynamoDB lock table

### CI (GitHub Actions)
- AWS IAM Role configured for **OIDC federation** from GitHub
- GitHub workflow permissions:
  - `id-token: write`
  - `contents: read`

---

## Terraform backend (state)

Each environment under `terraform/live/<env>` uses an S3 backend with DynamoDB state locking.

Typical structure:

- **S3 bucket**: `<TF_STATE_BUCKET>`
- **State key**: `<env>/terraform.tfstate`
- **DynamoDB lock table**: `<TF_LOCK_TABLE>`

---

## Environments

Environments are defined under `terraform/live/`.

- `staging/`
- `ephemeral/`

To add `prod/`, create `terraform/live/prod/` based on staging and update:
- backend state key (e.g. `prod/terraform.tfstate`)
- variables/`*.tfvars`
- GitHub workflow(s) and OIDC trust conditions (if you restrict by environment)

---

## How to run (local)

### Staging example
```
bash
cd terraform/live/staging
terraform init
terraform plan -var-file=staging.tfvars
terraform apply -var-file=staging.tfvars
```
### Destroy
```
bash
cd terraform/live/staging
terraform init
terraform destroy -var-file=staging.tfvars
```
> Tip: keep secrets and environment-specific values in `*.tfvars` files and/or environment variables, and do not commit sensitive values.

---

## Variables

Key inputs you’ll typically provide per-environment:

- `region`
- `environment`
- `app_id`
- `route53_zone_name`
- `api_file_upload_domain_name`
- `backend_certificate_arn`
- `uploads_bucket_name`
- `secret_store_name`
- `notification_email`
- `use_bucket_av` (optional)

---

## CI/CD workflows (GitHub Actions)

### Deploy
Workflow: `.github/workflows/deploy-backend-to-staging.yml`

- Uses OIDC to assume an AWS role
- Runs `terraform init` + `terraform apply`

### Destroy
Workflow: `.github/workflows/destroy-backend-staging-env.yml`

- Uses OIDC to assume an AWS role
- Runs `terraform init` + `terraform destroy`

> If you want the same workflows to support `ephemeral` and `prod`, expand the workflow input choices and ensure the IAM role trust policy allows those GitHub environments/refs.

