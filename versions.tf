###############################################
# versions.tf
#
# Este archivo fija versiones mínimas de Terraform
# y del proveedor de AWS para evitar cambios de
# comportamiento inesperados entre clases.
###############################################

terraform {
  # Versión mínima recomendada de Terraform CLI.
  required_version = ">= 1.5.0"

  # Proveedores que usa este proyecto.
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Versión estable moderna del provider de AWS.
      version = "~> 5.0"
    }
  }
}
