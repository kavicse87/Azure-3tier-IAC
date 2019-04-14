resource "azurerm_application_security_group" "webasg" {
  name = "webASG"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  location = "${var.location}"
  tags {
      environment = "${var.tag}"
  }
}

resource "azurerm_application_security_group" "appasg" {
  name = "appASG"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  location = "${var.location}"
  tags {
      environment = "${var.tag}"
  }
}

resource "azurerm_application_security_group" "dbasg" {
  name = "dbASG"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  location = "${var.location}"
  tags {
      environment = "${var.tag}"
  }
}