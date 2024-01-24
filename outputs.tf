output "elastic_beanstalk_endpoint_url" {
  value = module.beanstalk.eb_endpoint_url
}

output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "s3_bucket_id" {
  value = module.s3.bucket_id
}


