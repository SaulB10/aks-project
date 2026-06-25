variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "aks-rg"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "aksdemo"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for node access"
  type        = string
  default     = "~/.ssh/aks-key.pub"
}
