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
  subnet_id                   = var.subnet_ids[0]
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

# 1. Security Group para el ALB
resource "aws_security_group" "lb_sg" {
  name        = "alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. El Balanceador
resource "aws_lb" "app_lb" {
  name               = "backend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids 
}

# 3. El grupo de destino
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# 4. El Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 80
}