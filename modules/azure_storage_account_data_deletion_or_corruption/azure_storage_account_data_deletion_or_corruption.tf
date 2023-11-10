resource "shoreline_notebook" "azure_storage_account_data_deletion_or_corruption" {
  name       = "azure_storage_account_data_deletion_or_corruption"
  data       = file("${path.module}/data/azure_storage_account_data_deletion_or_corruption.json")
  depends_on = [shoreline_action.invoke_enable_soft_delete_and_versioning]
}

resource "shoreline_file" "enable_soft_delete_and_versioning" {
  name             = "enable_soft_delete_and_versioning"
  input_file       = "${path.module}/data/enable_soft_delete_and_versioning.sh"
  md5              = filemd5("${path.module}/data/enable_soft_delete_and_versioning.sh")
  description      = "Set up soft delete or versioning in the Azure storage account to protect against accidental data loss. This will allow deleted or overwritten files to be recovered within a certain time frame."
  destination_path = "/tmp/enable_soft_delete_and_versioning.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_enable_soft_delete_and_versioning" {
  name        = "invoke_enable_soft_delete_and_versioning"
  description = "Set up soft delete or versioning in the Azure storage account to protect against accidental data loss. This will allow deleted or overwritten files to be recovered within a certain time frame."
  command     = "`chmod +x /tmp/enable_soft_delete_and_versioning.sh && /tmp/enable_soft_delete_and_versioning.sh`"
  params      = ["RESOURCE_GROUP_NAME","STORAGE_ACCOUNT_NAME"]
  file_deps   = ["enable_soft_delete_and_versioning"]
  enabled     = true
  depends_on  = [shoreline_file.enable_soft_delete_and_versioning]
}

