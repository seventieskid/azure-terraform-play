#!/bin/bash 

CLIENT_ID=0050c121-c7d3-4c69-ae21-99d536cf86d0
RESOURCE_GROUP_NAME=frominsidecontainer
REGION=westeurope

# Special


# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $REGION

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