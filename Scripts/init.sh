#!/bin/bash
##TODO: VALIDATE
## TODO: "There are no credentials provided in your command and environment, we will query for account key for your storage account."
# TODO: CREATE FILE wo creating RG...KV
LOCATION="eastus"
PROJECT="escoolManual"
RESOURCE_GROUP_NAME="rg-secrets-$LOCATION"
STORAGE_ACCOUNT_NAME="storagetfstate$RANDOM"
CONTAINER_NAME="containertfstate"
KEYVAULT_NAME="kv-$PROJECT"

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
  echo "resource_group_name   = \"$RESOURCE_GROUP_NAME\"" \
        "storage_account_name = \"$STORAGE_ACCOUNT_NAME\"" \
        "container_name       = \"$CONTAINER_NAME\"" \
        "key                  = \"$KEYVAULT_NAME\"" >> $FILE
}

create_secret
create_file