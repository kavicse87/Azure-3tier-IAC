resource "azurerm_virtual_network" "myterraformvnet" {
  name = "myterraformvnet"
  address_space = ["10.0.0.0/16"]
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  tags {
      environment = "${var.tag}"
  }
}

resource "azurerm_subnet" "publicsnet1" {
    name = "publicsnet1"
    address_prefix = "10.0.0.0/24"
    virtual_network_name = "${azurerm_virtual_network.myterraformvnet.name}"
    resource_group_name = "${azurerm_resource_group.terrarg.name}"
}

resource "azurerm_subnet" "privatesnet1" {
  name = "privatesnet1"
  address_prefix = "10.0.1.0/24"
  virtual_network_name = "${azurerm_virtual_network.myterraformvnet.name}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
}

resource "azurerm_subnet" "privatesnet2" {
  name = "privatesnet2"
  address_prefix = "10.0.2.0/24"
  virtual_network_name = "${azurerm_virtual_network.myterraformvnet.name}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
}
