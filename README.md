
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Storage Account Data Deletion or Corruption

This incident type involves the accidental deletion or corruption of data in an Azure storage account. It can result in the permanent loss of critical data. The recommended resolution is to set up soft delete or versioning to protect against accidental data loss and regularly back up critical data.

### Parameters

```shell
export STORAGE_ACCOUNT_NAME="PLACEHOLDER"
export RESOURCE_GROUP_NAME="PLACEHOLDER"
export CONTAINER_NAME="PLACEHOLDER"
export CONNECTION_STRING="PLACEHOLDER"
export BLOB_NAME="PLACEHOLDER"
export VAULT_NAME="PLACEHOLDER"
```

## Debug

### Check if the storage account is still available

```shell
az storage account show --name ${STORAGE_ACCOUNT_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### List the blobs in a container to check if they're still accessible

```shell
az storage blob list --container-name ${CONTAINER_NAME} --connection-string '${CONNECTION_STRING}'
```

### Check if versioning is enabled for the storage account

```shell
az storage account blob-service-properties show --account-name ${STORAGE_ACCOUNT_NAME} --resource-group ${RESOURCE_GROUP_NAME} --query "isVersioningEnabled"
```

### Check if soft delete is enabled for the storage account

```shell
az storage account blob-service-properties show --account-name ${STORAGE_ACCOUNT_NAME} --resource-group ${RESOURCE_GROUP_NAME} --query "deleteRetentionPolicy.enabled"
```

### List the versions of a blob to check if they're still accessible

```shell
az storage blob list --connection-string '${CONNECTION_STRING}' --container-name ${CONTAINER_NAME} --include v -o json --query "reverse(sort_by([?name=='${BLOB_NAME}'], &versionId))[0].versionId"
```

### Check the logs for any suspicious activity that may have caused the data deletion or corruption

```shell
az monitor activity-log list
```

### Check the backup status to ensure that critical data is regularly backed up

```shell
az backup job list --resource-group ${RESOURCE_GROUP_NAME} --vault-name ${VAULT_NAME} --output table
```

## Repair

### Set up soft delete or versioning in the Azure storage account to protect against accidental data loss. This will allow deleted or overwritten files to be recovered within a certain time frame.

```shell
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
```