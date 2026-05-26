###############################################
# variables.tf
#
# Variables de entrada para hacer el proyecto
# reutilizable y fácil de explicar/modificar.
###############################################

variable "aws_region" {
  description = "Región de AWS donde se desplegará la instancia EC2."
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Nombre de la VPC existente (tag Name) donde se desplegará la instancia EC2."
  type        = string
  default     = "mi-vpc"
}

variable "instance_name" {
  description = "Nombre (tag Name) de la instancia EC2."
  type        = string
  default     = "demo-ec2-terraform"
}

variable "instance_type" {
  description = "Tipo de instancia EC2 (ej: t2.micro, t3.micro)."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nombre de un Key Pair existente en AWS para poder conectarte por SSH. Si no lo defines, no tendrás acceso SSH tradicional."
  type        = string
  default     = null
}

variable "ssh_ingress_cidr" {
  description = "Rango CIDR autorizado para SSH (puerto 22). Para clases/labs puedes usar 0.0.0.0/0, pero en producción limita a tu IP."
  type        = string
  default     = "0.0.0.0/0"
}

variable "project_tags" {
  description = "Tags comunes que se aplicarán a los recursos."
  type        = map(string)
  default = {
    Project     = "Terraform-EC2-Demo"
    Environment = "Teaching"
    ManagedBy   = "Terraform"
  }
}
