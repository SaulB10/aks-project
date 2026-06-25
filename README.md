# AKS Cluster with Terraform

Provisioning an Azure Kubernetes Service (AKS) cluster using Terraform and deploying a sample nginx application.

## Architecture

- **Resource Group** (`aks-rg`): Container for all Azure resources
- **AKS Cluster** (`aks-cluster`): Managed Kubernetes with 1 node (Standard_B2s)
- **nginx Deployment**: 2 replicas behind an Azure Load Balancer

## Files

| File | Description |
|------|-------------|
| `main.tf` | Core Terraform config: AKS cluster + Resource Group |
| `variables.tf` | Input variables (region, VM size, node count, etc.) |
| `outputs.tf` | Output values (cluster name, kubeconfig command) |
| `terraform.tfvars` | User-specific values — edit before running |
| `app.yaml` | Kubernetes manifest: nginx Deployment + LoadBalancer Service |

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- An Azure account with an active subscription

## How to Run

```bash
# 1. Log in to Azure
az login

# 2. Create a service principal (replace YOUR_SUBSCRIPTION_ID)
az ad sp create-for-rbac \
  --name "terraform-aks-sp" \
  --role Contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/aks-rg

# 3. Export credentials
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_TENANT_ID="<tenant>"
export ARM_SUBSCRIPTION_ID="<subscriptionId>"

# 4. Generate SSH keys
ssh-keygen -t rsa -b 4096 -f ~/.ssh/aks-key -N ""

# 5. Initialize and apply Terraform
terraform init
terraform plan
terraform apply

# 6. Connect to the cluster
az aks get-credentials --resource-group aks-rg --name aks-cluster --overwrite-existing
kubectl get nodes

# 7. Deploy the sample app
kubectl apply -f app.yaml
kubectl get service nginx-service --watch
# Open the EXTERNAL-IP in your browser

# 8. IMPORTANT — Destroy when done to save credit
terraform destroy
```

## Cost

- Standard_B2s: ~$0.04/hour
- Always run `terraform destroy` when you're done working
