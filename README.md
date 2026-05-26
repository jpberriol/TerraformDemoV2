# Terraform + EC2 (Demo para clase)

Este proyecto crea **una instancia EC2** en AWS usando Terraform, con enfoque educativo.
Todo el codigo contiene comentarios para que puedas explicar conceptos clave:

- Provider
- Variables
- Data sources
- Recursos
- Outputs
- Flujo `init -> plan -> apply -> destroy`

## Requisitos

1. Tener cuenta de AWS.
2. Tener credenciales configuradas en tu maquina (por ejemplo con `aws configure`).
3. Tener Terraform instalado (version 1.5+ recomendada).
4. Tener una VPC existente con tag `Name` y al menos una subnet en la region elegida.

## Estructura

- `versions.tf`: versiones de Terraform y provider.
- `provider.tf`: configuracion del provider de AWS.
- `variables.tf`: variables reutilizables.
- `main.tf`: recursos principales (SG + EC2).
- `outputs.tf`: salidas visibles tras `apply`.
- `terraform.tfvars.example`: ejemplo de valores para clase.
- `.gitignore`: evita subir estado/sensibles.

## Archivos obligatorios vs opcionales

### Obligatorios para ejecutar este proyecto

- `main.tf`: contiene los recursos principales y data sources.
- `provider.tf`: indica como conectarse a AWS (region).
- `variables.tf`: declara las variables usadas en el codigo.
- `versions.tf`: fija versiones de Terraform y del provider.

> Nota: `outputs.tf` no es obligatorio para crear recursos, pero si es muy recomendable para mostrar resultados..

### Opcionales (recomendados para buenas practicas)

- `outputs.tf`: muestra datos utiles al terminar (IP, DNS, URL).
- `terraform.tfvars`: define valores sin editar el codigo.
- `terraform.tfvars.example`: plantilla para crear rapido `terraform.tfvars`.
- `.gitignore`: evita subir estado y archivos sensibles al repositorio.

## Resumen rapido: para que sirve cada archivo

- `main.tf`: define que infraestructura se crea (EC2, SG, data sources).
- `provider.tf`: configura el proveedor `aws` y la region.
- `variables.tf`: define entradas parametrizables del proyecto.
- `versions.tf`: controla compatibilidad de versiones.
- `outputs.tf`: expone salidas utiles tras `terraform apply`.
- `terraform.tfvars`: valores reales de variables para un entorno.
- `terraform.tfvars.example`: ejemplo base para estudiantes.
- `.gitignore`: protege de subir archivos locales/sensibles.
- `README.md`: guia de uso y material de explicacion.

## Paso a paso para ejecutar

1. Copia el archivo de variables de ejemplo:

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edita `terraform.tfvars` y define al menos estos valores:

- `aws_region`
- `vpc_name` (debe coincidir con el tag `Name` real de tu VPC)
- `instance_name`
- `instance_type`

3. Inicializa Terraform (descarga provider):

```bash
terraform init
```

4. Revisa el plan de ejecucion:

```bash
terraform plan
```

5. Crea la infraestructura:

```bash
terraform apply
```

6. Al finalizar, revisa los outputs:

- `instance_id`
- `instance_public_ip`
- `instance_public_dns`
- `web_url`

7. Abre `web_url` en el navegador para validar que responde el servidor HTTP.

## Limpieza (muy importante)

Para no generar costos, destruye recursos al terminar la clase:

```bash
terraform destroy
```

## Conceptos

1. **Declarativo**: defines estado deseado, Terraform calcula acciones.
2. **State**: Terraform guarda estado en `terraform.tfstate`.
3. **Data source vs Resource**:
   - `data`: consulta algo existente (VPC/AMI).
   - `resource`: crea/administra algo nuevo (EC2/SG).
4. **Variables**: parametrizan la infraestructura.
5. **Outputs**: exponen datos utiles al final del despliegue.

## Notas de seguridad para estudiantes

- El CIDR `0.0.0.0/0` en SSH es util para demo, pero **inseguro** para produccion.
- En produccion, restringe `ssh_ingress_cidr` a tu IP publica.
- Nunca suba `terraform.tfstate` ni credenciales a repositorios publicos.
