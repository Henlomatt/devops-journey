resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Buscamos la AMI automáticamente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Usamos la referencia dinámica
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  # Nueva configuración de red
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  # Referencia al archivo de script
  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "AppServer-${var.bucket_name}"
  }
}

output "user_data_content" {
  value = file("${path.module}/user_data.sh")
}