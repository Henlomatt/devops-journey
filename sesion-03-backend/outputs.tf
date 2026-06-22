output "backend_bucket_arn" {
  value       = module.backend.s3_bucket_arn
}

output "backend_table_name" {
  value       = module.backend.dynamodb_table_name
}