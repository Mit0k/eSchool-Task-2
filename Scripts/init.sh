#!/bin/bash

LOCATION="eastus"
PROJECT="escool"
RESOURCE_GROUP_NAME="rg-secrets-$LOCATION"
STORAGE_ACCOUNT_NAME="tfstate$RANDOM"
CONTAINER_NAME="tfstate"
KEYVAULT_NAME="$PROJECT-keyvault"

create_secret()
{
  # Create resource group
  az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

  # Create storage account
  az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

  # Create blob container
  az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

  # Get account key
  ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

  # Create key vault
  az keyvault create --name $KEYVAULT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION

  # Adding account key to key vault
  az keyvault secret set --vault-name $KEYVAULT_NAME --name "terraform-backend-key" --value $ACCOUNT_KEY

  # Exporting key
  export ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-backend-key --vault-name $KEYVAULT_NAME --query value -o tsv)
}

create_file()
{
  readonly FILE=backend.conf
  if [ ! -f "$FILE" ]; then
    touch $FILE
  else
    echo > $FILE
  fi;
  echo "resource_group_name  = \"$RESOURCE_GROUP_NAME\"" >> $FILE
  echo "storage_account_name = \"$STORAGE_ACCOUNT_NAME\"" >> $FILE
  echo "container_name       = \"$CONTAINER_NAME\"" >> $FILE
  echo "key                  = \"$KEYVAULT_NAME\"" >> $FILE
}

create_secret
create_file