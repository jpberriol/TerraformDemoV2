###############################################
# main.tf
#
# Este archivo contiene la lógica principal:
# - Buscar VPC existente por nombre (tag Name)
# - Buscar subnets dentro de esa VPC
# - Crear Security Group
# - Crear instancia EC2
###############################################

###############################################
# 1) DATA SOURCES (lectura de recursos existentes)
###############################################

# Obtiene una VPC existente filtrando por su tag Name.
# El nombre se define en la variable var.vpc_name.
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Obtiene la subnet exacta que se quiere usar para la instancia.
# Esto fuerza el despliegue en una subnet puntual.
data "aws_subnet" "selected" {
  id = "subnet-0701bf55c6ff774ee"
}

# Busca la AMI más reciente de Amazon Linux 2023.
# Esto evita hardcodear un AMI ID por región.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

###############################################
# 2) SECURITY GROUP
###############################################

resource "aws_security_group" "ec2_sg" {
  # Nombre amigable para identificarlo en la consola.
  name        = "${var.instance_name}-sg"
  description = "Permite SSH y HTTP para demo educativa"
  # Usamos la VPC de la subnet elegida para evitar desalineacion.
  vpc_id = data.aws_subnet.selected.vpc_id

  # Regla de entrada para SSH (puerto 22).
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  # Regla de entrada para HTTP (puerto 80)
  # para poder mostrar una pagina de prueba.
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de salida: permite todo trafico saliente.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Mezclamos tags comunes + Name especifico del recurso.
  tags = merge(
    var.project_tags,
    {
      Name = "${var.instance_name}-sg"
    }
  )
}

###############################################
# 3) EC2 INSTANCE
###############################################

resource "aws_instance" "demo" {
  # AMI resuelta automaticamente por data source.
  ami = data.aws_ami.amazon_linux.id

  # Tipo de instancia configurable por variable.
  instance_type = var.instance_type

  # Colocamos la instancia en la subnet fija solicitada.
  subnet_id = data.aws_subnet.selected.id

  # Asocia una IP publica automaticamente (util para demo).
  associate_public_ip_address = true

  # Security group creado en este mismo proyecto.
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Key pair opcional para SSH.
  key_name = var.key_name

  # Script de arranque para instalar y levantar un servidor web.
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>EC2 creada con Terraform</h1>" > /var/www/html/index.html
              EOF

  # Tags para clasificacion y trazabilidad.
  tags = merge(
    var.project_tags,
    {
      Name = var.instance_name
    }
  )
}
