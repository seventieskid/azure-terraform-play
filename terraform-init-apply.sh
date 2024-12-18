#!/bin/bash 

CLIENT_ID=b956e4d2-1f4d-45d5-91c2-baa0c9b9e761
RESOURCE_GROUP_NAME=frominsidecontainer
REGION=westeurope

echo "system-access-token="
echo $SYSTEM_ACCESSTOKEN

echo $SYSTEM_ACCESSTOKEN | az devops login

az devops project list

#az login --identity --username $CLIENT_ID

# Create resource group
#az group create --name $RESOURCE_GROUP_NAME --location $REGION

# Create storage account
# az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# # Create blob container
# az storage container create --name xyz --account-name $STORAGE_ACCOUNT_NAME

# # See https://developer.hashicorp.com/terraform/language/backend/azurerm
# terraform init -backend=true \
#                -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
#                -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
#                -backend-config="container_name=$CONTAINER_NAME"  \
#                -backend-config="key=terraform.tfstate"  \
#                -backend-config="use_azuread_auth=true"  \
#                -backend-config="use_oidc=true"

# terraform apply -auto-approve