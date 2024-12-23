#!/bin/bash 

RESOURCE_GROUP_NAME=terraform-test-rg
STORAGE_ACCOUNT_NAME=terraformgarethrees
STORAGE_CONTAINER_NAME=terraform-state
REGION=westeurope

export ARM_SUBSCRIPTION_ID=$(az account list | jq -r '.[0].id')

# Prep for tf state storage
az group create --name $RESOURCE_GROUP_NAME --location $REGION

az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

az storage container create --name $STORAGE_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# Allow the service principal to get access keys for the storage account
az role assignment create \
    --role "Storage Account Contributor" \
    --assignee-object-id "3cb931d6-05df-4d9f-b3b7-adefd0b6db60" \
    --assignee-principal-type "ServicePrincipal" \
    --scope "/subscriptions/$ARM_SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT_NAME/blobServices/default/containers/$STORAGE_CONTAINER_NAME"

# Because the below is commented out, terraform is falling back on the SPN contents to run, not the MSI
#export ARM_USE_MSI=true

export ARM_CLIENT_ID=$(az keyvault secret show --name azuron-spn-client-id --vault-name azuron --query "value")
export ARM_CLIENT_SECRET=$(az keyvault secret show --name azuron-spn-secret-id --vault-name azuron --query "value")
export ARM_TENANT_ID=$(az account list | jq -r '.[0].tenantId')
export ARM_SUBSCRIPTION_ID=$(az account list | jq -r '.[0].id')

export ARM_ACCESS_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

export TF_DATA_DIR=/tmp/.terraform

# See https://developer.hashicorp.com/terraform/language/backend/azurerm
terraform init -backend=true \
               -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
               -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
               -backend-config="container_name=$STORAGE_CONTAINER_NAME"  \
               -backend-config="key=terraform.tfstate"

terraform apply -auto-approve