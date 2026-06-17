terraform {
  backend "s3" {
    bucket         = "mi-proyecto-terraform-2026-henlomatt" # El nombre que creaste
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock" # La tabla que creaste
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

# (Mantén tus recursos de s3 y dynamodb aquí abajo)

resource "aws_s3_bucket" "terraform_state" {
  bucket = "mi-proyecto-terraform-2026-henlomatt" # Debe ser un nombre único globalmente
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}