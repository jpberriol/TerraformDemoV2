###############################################
# provider.tf
#
# Aquí definimos cómo Terraform se conecta a AWS.
###############################################

provider "aws" {
  # Región donde se crearán los recursos.
  # Se toma desde variables.tf y terraform.tfvars.
  region = var.aws_region
}
