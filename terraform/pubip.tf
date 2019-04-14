resource "azurerm_public_ip" "webserver_ip" {
  name = "webserverIP"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  allocation_method = "Dynamic"
  tags {
      environment = "${var.tag}"
  }
}
