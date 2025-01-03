#!/bin/bash 

RESOURCE_GROUP_NAME=terraform-test-rg
STORAGE_ACCOUNT_NAME=terraformgarethrees
STORAGE_CONTAINER_NAME=terraform-state
REGION=westeurope

# Prep for tf state storage
az group create --name $RESOURCE_GROUP_NAME --location $REGION

az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

az storage container create --name $STORAGE_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

export ARM_USE_MSI=true
export ARM_TENANT_ID=$(az account list | jq -r '.[0].tenantId')
export ARM_SUBSCRIPTION_ID=$(az account list | jq -r '.[0].id')

export TF_DATA_DIR=/tmp/.terraform

# See https://developer.hashicorp.com/terraform/language/backend/azurerm
terraform init -backend=true \
               -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
               -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
               -backend-config="container_name=$STORAGE_CONTAINER_NAME"  \
               -backend-config="key=terraform.tfstate"

terraform apply -auto-approve