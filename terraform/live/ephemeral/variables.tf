variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "ephemeral"
}

variable "app_id" {
  description = "Application identifier to be used in tags"
  type        = string
}

variable "uploads_bucket_name" {
  description = "The name of the S3 bucket for file uploads"
  type        = string
  default     = "uploads-bucket"
}

variable "backend_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "api_file_upload_domain_name" {
  description = "The domain name for the API to get pre-signed file upload URLs"
  type        = string
  default     = "api-file-upload.epic-trip-planner.com"
}

variable "secret_store_name" {
  description = "Name of the secret store where API_GW_AUTH_SECRET value can be fetched"
  type        = string
}

variable "route53_zone_name" {
  description = "Route 53 zone name (e.g., epic-trip-planner.com)"
  type        = string
}

variable "notification_email" {
  description = "Email address for notifications"
  type        = string
}