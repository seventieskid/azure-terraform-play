#!/bin/bash 

RESOURCE_GROUP_NAME=terraform-test-rg
STORAGE_ACCOUNT_NAME=terraformteststorageac
STORAGE_CONTAINER_NAME=terraform-state
REGION=westeurope

# Prep for tf state storage
az group create --name $RESOURCE_GROUP_NAME --location $REGION
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
az storage container create --name $STORAGE_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# See https://developer.hashicorp.com/terraform/language/backend/azurerm
terraform init -backend=true \
               -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
               -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
               -backend-config="container_name=$STORAGE_CONTAINER_NAME"  \
               -backend-config="key=terraform.tfstate"  \
               -backend-config="use_azuread_auth=true"  \
               -backend-config="use_oidc=true"

terraform apply -auto-approve