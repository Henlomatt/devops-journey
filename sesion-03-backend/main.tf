terraform {
  backend "s3" {
    bucket         = "mi-proyecto-terraform-2026-henlomatt"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "backend" {
  source      = "./modules/backend"
  bucket_name = "mi-proyecto-terraform-2026-henlomatt"
  table_name  = "terraform-lock"
}