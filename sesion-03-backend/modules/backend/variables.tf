variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}

variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" { type = string }
variable "security_group_id" { type = string }