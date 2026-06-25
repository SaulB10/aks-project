# Clúster AKS con Terraform

**Saul Barillas**
**999017182**

Aprovisionamiento de un clúster de Azure Kubernetes Service (AKS) usando Terraform y despliegue de una aplicación nginx.

## Arquitectura

- **Resource Group** (`aks-rg`): Contenedor lógico para todos los recursos de Azure
- **AKS Cluster** (`aks-cluster`): Kubernetes administrado con 1 nodo (Standard_D2s_v7)
- **nginx Deployment**: 2 réplicas detrás de un Azure Load Balancer

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `main.tf` | Configuración principal de Terraform: clúster AKS + Resource Group |
| `variables.tf` | Variables de entrada (región, tamaño de VM, número de nodos, etc.) |
| `outputs.tf` | Valores de salida (nombre del clúster, comando para kubeconfig) |
| `terraform.tfvars` | Valores específicos del usuario — editar antes de ejecutar |
| `app.yaml` | Manifiesto de Kubernetes: Deployment de nginx + Service LoadBalancer |

## Requisitos

- [Azure CLI](https://learn.microsoft.com/es-es/cli/azure/install-azure-cli)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Una cuenta de Azure con una suscripción activa

## Cómo ejecutar

```bash
# 1. Iniciar sesión en Azure
az login

# 2. Crear un service principal (reemplazar TU_SUBSCRIPTION_ID)
az ad sp create-for-rbac \
  --name "terraform-aks-sp" \
  --role Contributor \
  --scopes /subscriptions/TU_SUBSCRIPTION_ID

# 3. Exportar credenciales como variables de entorno
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_TENANT_ID="<tenant>"
export ARM_SUBSCRIPTION_ID="<subscriptionId>"

# 4. Generar llaves SSH
ssh-keygen -t rsa -b 4096 -f ~/.ssh/aks-key -N ""

# 5. Inicializar y aplicar Terraform
terraform init
terraform plan
terraform apply

# 6. Conectarse al clúster
az aks get-credentials --resource-group aks-rg --name aks-cluster --overwrite-existing
kubectl get nodes

# 7. Desplegar la aplicación
kubectl apply -f app.yaml
kubectl get service nginx-service --watch
# Abrir la EXTERNAL-IP en el navegador

# 8. IMPORTANTE — Destruir al terminar para no gastar crédito
terraform destroy
```

## Costo

- Standard_D2s_v7: ~$2-3 USD por día
- Siempre ejecutar `terraform destroy` al terminar de trabajar
