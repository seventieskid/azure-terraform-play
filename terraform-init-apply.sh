#!/bin/bash

RESOURCE_GROUP_NAME=azuron-play-eu-west
STORAGE_ACCOUNT_NAME=azuronplayeuwest
CONTAINER_NAME=terraforma-azuron-play-eu-west
REGION=westeu

curl -v http://169.254.169.254

az login --identity --username 2dcef099-1705-43eb-abef-7ab2781403a4

# # Create resource group
# az group create --name $RESOURCE_GROUP_NAME --location $REGION

# # Create storage account
# az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --auth-mode login

# See https://developer.hashicorp.com/terraform/language/backend/azurerm
terraform init -backend=true \
               -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
               -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
               -backend-config="container_name=$CONTAINER_NAME"  \
               -backend-config="key=terraform.tfstate"  \
               -backend-config="use_azuread_auth=true"  \
               -backend-config="use_oidc=true"

terraform apply -auto-approve