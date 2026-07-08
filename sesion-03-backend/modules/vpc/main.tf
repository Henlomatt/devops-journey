resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Subred 1 (Irlanda)
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "eu-west-1a" # Cambiado a Irlanda
  tags = { Name = "${var.environment}-public-subnet-1" }
}

# Subred 2 (Irlanda)
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone = "eu-west-1b" # Cambiado a Irlanda
  tags = { Name = "${var.environment}-public-subnet-2" }
}

# 1. Internet Gateway: Permite la conexión a Internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# 2. Tabla de rutas: Define que el tráfico destinado a Internet (0.0.0.0/0) vaya al IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

# 3. Asociación: Vincula la tabla de rutas con tu subred pública
# Asociaciones para ambas subredes públicas
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# 4. Security Group: Firewall para controlar el tráfico
resource "aws_security_group" "allow_ssh" {
  name        = "${var.environment}-allow-ssh"
  description = "Permitir trafico SSH"
  vpc_id      = aws_vpc.main.id

  # Regla de entrada: Permite SSH (puerto 22) desde cualquier IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla adicional para permitir HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de salida: Permite todo el trafico hacia afuera
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ssh-sg"
  }
}