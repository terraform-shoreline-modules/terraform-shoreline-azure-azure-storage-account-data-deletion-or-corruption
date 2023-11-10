#!/bin/bash

# Set variables
resource_group=${RESOURCE_GROUP_NAME}
storage_account=${STORAGE_ACCOUNT_NAME}

# Enable soft delete on the storage account
az storage account blob-service-properties update \
  --resource-group $resource_group \
  --account-name $storage_account \
  --enable-delete-retention true \
  --delete-retention-days 30

# Enable versioning on the storage account
az storage account blob-service-properties update \
  --resource-group $resource_group \
  --account-name $storage_account \
  --enable-versioning true