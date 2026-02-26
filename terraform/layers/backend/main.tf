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


# TODO all function below will be integrated as part of file_uploader core code
# module "lambda_functions" {
#   source = "./modules/lambda_function"
#
#   # for_each to loop over lambda_configs to set up get_presigned_url and process_uploaded_file lambdas
#   for_each = local.lambda_configs
#
#   # Pass common variables
#   environment = var.environment
#   app_id      = var.app_id
#
#   # Pass variables specific to the current iteration (key is the map key, value is the map content)
#   lambda_name           = each.value.base_name
#   source_dir            = each.value.source_dir
#   handler_file          = each.value.handler_file
#   runtime               = each.value.runtime
#   environment_vars      = each.value.environment_vars
#   s3_bucket             = each.value.s3_bucket != null ? each.value.s3_bucket : ""
#   s3_key                = each.value.s3_key != null ? each.value.s3_key : ""
#   iam_policy_statements = each.value.iam_policy_statements
# }
#
#
# module "api_gateway" {
#   source = "./modules/api_gateway"
#
#   app_id                                 = var.app_id
#   cloudfront_domain_name                 = var.alt_cloudfront_domain_name
#   environment                            = var.environment
#   region                                 = var.region
#   lambda_get_document_data_arn           = module.lambda_functions["get_document_data"].function_arn
#   lambda_get_document_data_function_name = module.lambda_functions["get_document_data"].function_name
#   lambda_get_file_arn                    = module.lambda_functions["get_file"].function_arn
#   lambda_get_file_function_name          = module.lambda_functions["get_file"].function_name
#   lambda_list_files_arn                  = module.lambda_functions["list_files"].function_arn
#   lambda_list_files_function_name        = module.lambda_functions["list_files"].function_name
#
#   depends_on = [module.lambda_functions]
# }