output "s3_bucket_arn" {
  description = "ARN del bucket S3 de estado"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "Nombre de la tabla de bloqueo DynamoDB"
  value       = aws_dynamodb_table.terraform_lock.name
}