az group create \
--location westeurope \
--name azuron-devops-agents

# Support request out for Standard_B2pts_v2 50 x cheaper than

# With private IP
# az vmss create \
# --name azuron-vmssagents-pool \
# --resource-group azuron-vmssagents \
# --image Ubuntu2204 \
# --authentication-type SSH \
# --admin-username grees \
# --generate-ssh-keys \
# --instance-count 1 \
# --disable-overprovision \
# --upgrade-policy-mode manual \
# --single-placement-group false \
# --platform-fault-domain-count 1 \
# --load-balancer "" \
# --custom-data /Users/garethrees/gitrepos/azure-terraform-play/cloud-config.yml \
# --orchestration-mode Uniform


# With public IP
az vmss create \
  --name azuron-devops-agents \
  --resource-group azuron-devops-agents \
  --image Ubuntu2204 \
  --custom-data /Users/garethrees/gitrepos/azure-terraform-play/cloud-config.yml \
  --admin-username azuron \
  --authentication-type SSH \
  --generate-ssh-keys \
  --instance-count 1 \
  --disable-overprovision \
  --upgrade-policy-mode manual \
  --single-placement-group false \
  --platform-fault-domain-count 1 \
  --orchestration-mode Uniform

ssh azuron@104.40.188.147 -p 50000

# Create and assign user managed identity to VM Scale Set
az identity create --name azuron-devops-agents --resource-group azuron-devops-agents
# Manually for now drop client id into ci.yaml

az vmss identity assign --identities azuron-devops-agents --name azuron-devops-agents --resource-group azuron-devops-agents
az vmss update-instances -g azuron-devops-agents -n azuron-devops-agents --instance-ids 0
# Associate role wiht MSI goes here

# Az DevOps command to add agent pool goes here
# /agent directory only pops up after around 10 minutes after creating pool with VMSS

# Delete resource group
az group delete --name azuron-devops-agents


# Current issue...

AzDevOps@azurod351000000:/agent/_work/1/s$ ls -al
total 12
drwxr-xr-x 3 AzDevOps AzDevOps 4096 Dec 20 17:07 .
drwxr-xr-x 3 AzDevOps AzDevOps 4096 Dec 20 17:07 ..
drwxr-xr-x 3 root     root     4096 Dec 20 17:05 .terraform

rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers
rm: could not remove file (code EACCES): /agent/_work/1/s/.terraform/terraform.tfstate
rm: could not remove directory (code ENOTEMPTY): /agent/_work/1/s/.terraform
rm: could not remove file (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm/4.13.0/linux_amd64/LICENSE.txt
rm: could not remove file (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm/4.13.0/linux_amd64/terraform-provider-azurerm_v4.13.0_x5
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm/4.13.0/linux_amd64
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm/4.13.0
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers
rm: could not remove file (code EACCES): /agent/_work/1/s/.terraform/terraform.tfstate
rm: could not remove directory (code ENOTEMPTY): /agent/_work/1/s/.terraform
rm: could not remove directory (code ENOTEMPTY): /agent/_work/1/s
##[error]Error: Failed rmRF: rm: could not remove file (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm/4.13.0/linux_amd64/LICENSE.txt
rm: could not remove file (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm/4.13.0/linux_amd64/terraform-provider-azurerm_v4.13.0_x5
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm/4.13.0/linux_amd64
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm/4.13.0
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp/azurerm
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io/hashicorp
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers/registry.terraform.io
rm: could not remove directory (code EACCES): /agent/_work/1/s/.terraform/providers
rm: could not remove file (code EACCES): /agent/_work/1/s/.terraform/terraform.tfstate
rm: could not remove directory (code ENOTEMPTY): /agent/_work/1/s/.terraform
rm: could not remove directory (code ENOTEMPTY): /agent/_work/1/s
##[error]Couldn't delete one or more files
Finishing: clean *
