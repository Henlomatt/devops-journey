module "backend_dev" {
  source      = "../../modules/backend"
  bucket_name = var.bucket_name
  table_name  = var.table_name
  instance_type = "t3.micro"
}