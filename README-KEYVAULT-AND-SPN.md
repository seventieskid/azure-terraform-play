# Azure Terraform Play

Here we setup and run Hashicorp Terrafom in Azure DevOps CI/CD pipelines by bringing our own:-

- Azure DevOps Self-Hosted Agents
- A fully tooled docker container with the Hashicorp Terrafom on it
- Simple authentication and authorisation using Service Principal Names from Azure Key Vault

## Bootstrap Azure: Create Resource Group
```
az group create \
--location westeurope \
--name azuron-keyvault
```

## Bootstrap Azure: Create Key Vault
```
az keyvault create --name azuron --resource-group azuron-keyvault

Where: xyz is the UUID of the human vault admin

az role assignment create --assignee "xyz" \
        --role "Key Vault Administrator" \
        --scope "/subscriptions/60e1436b-d08b-466d-b42a-98011fed3eb2/resourceGroups/azuron-keyvault"
```

## Bootstrap Azure: Create Service Principal Name (SPN)
```
SPN_OUT=$(az ad sp create-for-rbac --display-name azuron-spn-new --role="Contributor" --scopes="/subscriptions/60e1436b-d08b-466d-b42a-98011fed3eb2")

SPN_CLIENT_ID=$(echo $SPN_OUT | jq -r '.appId' | tr -d '"')
SPN_SECRET_ID=$(echo $SPN_OUT | jq -r '.password' | tr -d '"')

az keyvault secret set --vault-name "azuron" --name "azuron-spn-new-client-id" --value "${SPN_CLIENT_ID}"
az keyvault secret set --vault-name "azuron" --name "azuron-spn-new-secret-id" --value "${SPN_SECRET_ID}"
```

