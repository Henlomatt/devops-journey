module "vpc_dev" {
  source      = "../../modules/vpc"
  environment = "dev"
}

module "backend_dev" {
  source            = "../../modules/backend"
  bucket_name       = var.bucket_name
  table_name        = var.table_name
  instance_type     = "t3.micro"
  
  # Ahora pasamos la lista completa de subredes
  vpc_id            = module.vpc_dev.vpc_id
  subnet_ids        = module.vpc_dev.public_subnet_ids
  security_group_id = module.vpc_dev.security_group_id
}

output "public_ip" {
  value = module.backend_dev.instance_public_ip
}