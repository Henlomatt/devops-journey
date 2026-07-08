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

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de las subredes"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID del grupo de seguridad para la instancia"
  type        = string
}