###############################################
# outputs.tf
#
# Valores de salida para mostrar resultados utiles
# despues de terraform apply.
###############################################

output "instance_id" {
  description = "ID de la instancia EC2 creada."
  value       = aws_instance.demo.id
}

output "instance_public_ip" {
  description = "IP publica de la instancia EC2."
  value       = aws_instance.demo.public_ip
}

output "instance_public_dns" {
  description = "DNS publico de la instancia EC2."
  value       = aws_instance.demo.public_dns
}

output "web_url" {
  description = "URL HTTP para validar la pagina de prueba instalada por user_data."
  value       = "http://${aws_instance.demo.public_dns}"
}
