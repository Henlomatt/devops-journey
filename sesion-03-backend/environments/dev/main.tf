module "vpc_dev" {
  source      = "../../modules/vpc"
  environment = "dev"
}

module "backend_dev" {
  source            = "../../modules/backend"
  bucket_name       = var.bucket_name
  table_name        = var.table_name
  instance_type     = "t3.micro"
  
  # Pasamos los recursos de red recién creados
  subnet_id         = module.vpc_dev.public_subnet_id
  security_group_id = module.vpc_dev.security_group_id
}

output "public_ip" {
  value = module.backend_dev.instance_public_ip
}