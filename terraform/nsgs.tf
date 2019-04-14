resource "azurerm_network_security_group" "pubsnetNSG" {
    name = "pubsnet1NSG"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.terrarg.name}"
    security_rule {
        name  = "SSH_Rule"
        priority = 100
        protocol = "Tcp"
        direction = "Inbound"
        access = "Allow"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_port_range = "22"
        destination_application_security_group_ids = ["${azurerm_application_security_group.webasg.id}"]
    }
    tags = {
        environment = "${var.tag}"
    }
}

resource "azurerm_network_security_group" "privatesnet1NSG" {
  name = "privatesnet1NSG"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  security_rule {
      name = "SSH_Access_From_Web"
      priority = 100
      protocol = "Tcp"
      direction = "Inbound"
      access = "Allow"
      source_application_security_group_ids = ["${azurerm_application_security_group.webasg.id}"]
      source_port_range = "*"
      destination_port_range = "22"
      destination_application_security_group_ids = ["${azurerm_application_security_group.appasg.id}"]
  }
  tags {
      environment = "${var.tag}"
  }
}

resource "azurerm_network_security_group" "privatesnet2NSG" {
    name = "privatesnet2NSG"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.terrarg.name}"
    security_rule {
        name = "SSH_Access_From_web"
        priority = 100
        protocol = "Tcp"
        access = "Allow"
        direction = "Inbound"
        source_application_security_group_ids = ["${azurerm_application_security_group.webasg.id}"]
        source_port_range = "*"
        destination_application_security_group_ids = ["${azurerm_application_security_group.webasg.id}"]
        destination_port_range = "22"
    }
    tags {
        environment = "${var.tag}"
    } 
}

resource "azurerm_network_security_rule" "webaccess" {
  name = "web_access"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  network_security_group_name = "${azurerm_network_security_group.pubsnetNSG.name}"
  priority = 101
  protocol = "Tcp"
  direction = "Inbound"
  access = "Allow"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_application_security_group_ids = ["${azurerm_application_security_group.webasg.id}"]
  destination_port_ranges = [80,443]

}

resource "azurerm_network_security_rule" "denyallnsg1" {
  name = "Deny_all_unwanted_Requests"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  network_security_group_name = "${azurerm_network_security_group.pubsnetNSG.name}"
  priority = 102
  protocol = "Tcp"
  access = "Deny"
  direction = "Inbound"
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_range = "*"
}

resource "azurerm_network_security_rule" "appaccess" {
  name="App_Access"
  network_security_group_name = "${azurerm_network_security_group.privatesnet1NSG.name}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  priority = 101
  protocol = "Tcp"
  access = "Allow"
  direction = "Inbound"
  source_port_range = "*"
  source_application_security_group_ids = ["${azurerm_application_security_group.webasg.id}"]
  destination_application_security_group_ids = ["${azurerm_application_security_group.appasg.id}"]
  destination_port_range = "8080"
}

resource "azurerm_network_security_rule" "denyallonnsg2" {
  name = "Deny_all_unwanted_requests"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  network_security_group_name = "${azurerm_network_security_group.privatesnet1NSG.name}"
  priority = 102
  protocol = "Tcp"
  access = "Deny"
  direction = "Inbound"
  source_port_range = "*"
  source_address_prefix = "*"
  destination_port_range = "*"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "dbaccess" {
  name = "Database_Access"
  network_security_group_name = "${azurerm_network_security_group.privatesnet2NSG.name}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  priority = 101
  protocol = "Tcp"
  access = "Allow"
  direction = "Inbound"
  source_port_range = "*"
  source_application_security_group_ids = ["${azurerm_application_security_group.appasg.id}"]
  destination_port_range = 3306
  destination_application_security_group_ids = ["${azurerm_application_security_group.dbasg.id}"]
}

resource "azurerm_network_security_rule" "denyallonnsg3" {
    name = "Deny_all_unwanted_requests"
    resource_group_name = "${azurerm_resource_group.terrarg.name}"
    network_security_group_name = "${azurerm_network_security_group.privatesnet2NSG.name}"
    priority = 102
    protocol = "Tcp"
    access = "Deny"
    direction = "Inbound"
    source_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    destination_port_range = "*"
}