resource "azurerm_network_interface" "webservernic" {
  name = "webservernic"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  location = "${var.location}"
  ip_configuration {
      name = "webserver_local_ip"
      subnet_id = "${azurerm_subnet.publicsnet1.id}"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = "${azurerm_public_ip.webserver_ip.id}"
  }
  tags {
      environment = "${var.tag}"
  }
}
resource "azurerm_network_interface_application_security_group_association" "webnic_asg_mount" {
  network_interface_id = "${azurerm_network_interface.webservernic.id}"
  application_security_group_id = "${azurerm_application_security_group.webasg.id}"
  ip_configuration_name = "webserver_local_ip"
}

resource "azurerm_network_interface" "appservernic" {
    name = "appservernic"
    resource_group_name = "${azurerm_resource_group.terrarg.name}"
    location = "${var.location}"
    ip_configuration {
        name = "appserver_local_ip"
        subnet_id = "${azurerm_subnet.privatesnet1.id}"
        private_ip_address_allocation = "Dynamic"
    }
    tags {
        environment = "${var.tag}"
    }
}

resource "azurerm_network_interface_application_security_group_association" "appnic_asg_mount" {
  network_interface_id = "${azurerm_network_interface.appservernic.id}"
  application_security_group_id = "${azurerm_application_security_group.appasg.id}"
  ip_configuration_name = "appserver_local_ip"
}

resource "azurerm_network_interface" "dbservernic" {
  name = "dbservernic"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  ip_configuration {
      name = "dbserver_local_ip"
      private_ip_address_allocation = "Dynamic"
      subnet_id = "${azurerm_subnet.privatesnet2.id}"
  }
}

resource "azurerm_network_interface_application_security_group_association" "dbnic_asg_mount" {
  network_interface_id = "${azurerm_network_interface.dbservernic.id}"
  application_security_group_id = "${azurerm_application_security_group.dbasg.id}"
  ip_configuration_name = "dbserver_local_ip"
}
