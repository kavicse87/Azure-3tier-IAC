resource "azurerm_storage_account" "mystorageaccount" {
  name = "tf220190413"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  location = "${var.location}"
  account_replication_type = "LRS"
  account_tier = "Standard"

  tags {
      environment = "${var.tag}"
  }
}