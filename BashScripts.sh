#!/bin/bash
#COnnect and set Subscription Context in Azure
az login
az account set --subscription "Azure ProServe Training"


#Set Variables for Storage account and Key Vault that support the Terraform implementation
RESOURCE_GROUP_NAME="RG-AKS-Sen-Train-39903"
STORAGE_ACCOUNT_NAME="saterraformsen"
CONTAINER_NAME=tstate
STATE_FILE="terraform.state"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location useast

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key (Only used if SPN not available)
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

# Show details for the purposes of this code
echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
echo "state_file: $STATE_FILE"

# Create KeyVault and example of storing a key
az keyvault create --name "terraformkv" --resource-group "RG-AKS-Sen-Train-39903" --location useast
az keyvault secret set --vault-name "terraformkv" --name "tstateaccess" --value {$ACCOUNT_KEY}
az keyvault secret show --vault-name "terraformkv" --name "tstateaccess"
