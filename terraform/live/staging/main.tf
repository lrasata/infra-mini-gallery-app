module "staging_mini_gallery_app" {
  source = "../../layers/backend"

  region                      = var.region
  environment                 = var.environment
  app_id                      = var.app_id
  secret_store_name           = var.secret_store_name
  api_file_upload_domain_name = var.api_file_upload_domain_name
  backend_certificate_arn     = var.backend_certificate_arn
  uploads_bucket_name         = var.uploads_bucket_name
  route53_zone_name           = var.route53_zone_name
  notification_email          = var.notification_email
}