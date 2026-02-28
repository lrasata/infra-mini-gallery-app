data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "mini_gallery_app_secrets" {
  name = "${var.environment}/${var.app_id}/secrets"
}

module "file_uploader" {
  source = "git::https://github.com/lrasata/infra-file-uploader//terraform/modules/file_uploader?ref=v1.7.0-beta.1"

  region                       = var.region
  app_id                       = var.app_id
  environment                  = var.environment
  secret_store_name            = data.aws_secretsmanager_secret.mini_gallery_app_secrets.name
  api_file_upload_domain_name  = var.api_file_upload_domain_name
  backend_certificate_arn      = var.backend_certificate_arn
  uploads_bucket_name          = var.uploads_bucket_name
  enable_transfer_acceleration = var.enable_transfer_acceleration
  notification_email           = var.notification_email
  route53_zone_name            = var.route53_zone_name
}

module "image_moderator" {
  source = "git::https://github.com/lrasata/infra-s3-image-moderator//modules/s3_image_moderator?ref=v1.1.2"

  region                    = var.region
  environment               = var.environment
  app_id                    = var.app_id
  s3_src_bucket_name        = module.file_uploader.uploads_bucket_id
  s3_src_bucket_arn         = module.file_uploader.uploads_bucket_arn
  s3_quarantine_bucket_name = "${var.quarantine_bucket_name}-${data.aws_caller_identity.current.account_id}"
  admin_email               = var.notification_email
}