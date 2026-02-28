variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
}

variable "app_id" {
  description = "Name which identifies the deployed app"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "secret_store_name" {
  description = "Name of the secret store where API_GW_AUTH_SECRET value can be fetched"
  type        = string
}

#-------------- File uploader variables -----------------------------------------------
# START
variable "api_file_upload_domain_name" {
  description = "The domain name for the API to get pre-signed file upload URLs"
  type        = string
}

variable "uploads_bucket_name" {
  description = "The name of the S3 bucket for file uploads"
  type        = string
  default     = "uploads-bucket"
}

variable "backend_certificate_arn" {
  description = "The ARN of the ACM certificate for the API Gateway"
  type        = string
}

variable "enable_transfer_acceleration" {
  type        = bool
  description = "Enable S3 Transfer Acceleration?"
  default     = false
}

variable "notification_email" {
  description = "Email address for notifications"
  type        = string
}

variable "route53_zone_name" {
  description = "Route53 zone name"
  type        = string
}
# END

variable "quarantine_bucket_name" {
  description = "S3 quarantine bucket name for flagged content"
  type        = string
  default     = "quarantine-bucket"
}