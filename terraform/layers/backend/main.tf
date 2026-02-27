data "aws_secretsmanager_secret" "mini_gallery_app_secrets" {
  name = "${var.environment}/${var.app_id}/secrets"
}

module "file_uploader" {
  source = "git::https://github.com/lrasata/infra-file-uploader//terraform/modules/file_uploader?ref=feature/node-js-upgrade-refactor-to-ts"

  region                                        = var.region
  app_id                                        = var.app_id
  environment                                   = var.environment
  secret_store_name                             = data.aws_secretsmanager_secret.mini_gallery_app_secrets.name
  api_file_upload_domain_name                   = var.api_file_upload_domain_name
  backend_certificate_arn                       = var.backend_certificate_arn
  uploads_bucket_name                           = var.uploads_bucket_name
  enable_transfer_acceleration                  = var.enable_transfer_acceleration
  lambda_upload_presigned_url_expiration_time_s = var.lambda_upload_presigned_url_expiration_time_s
  use_bucket_av                                 = var.use_bucket_av
  bucket_av_sns_findings_topic_name             = var.bucket_av_sns_findings_topic_name
  lambda_memory_size_mb                         = var.lambda_memory_size_mb
  notification_email                            = var.notification_email
  route53_zone_name                             = var.route53_zone_name
}