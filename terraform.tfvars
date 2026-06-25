
resource_group_name = "aks-rg"
location            = "eastus"          # Opciones cercanas a Guatemala: "southcentralus" (Texas)
cluster_name        = "aks-cluster"
dns_prefix          = "aksdemo"
node_count          = 1                 # 1 nodo es suficiente para el lab (más barato)
vm_size             = "Standard_D2s_v7"    # VM económica (~$0.04/hora)
ssh_public_key_path = "C:/Users/saulb/.ssh/aks-key.pub"
