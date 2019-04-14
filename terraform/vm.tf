resource "azurerm_virtual_machine" "webserver" {
  name = "webserver"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  network_interface_ids = ["${azurerm_network_interface.webservernic.id}"]
  vm_size = "Standard_B1s"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true
  storage_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "18.04-LTS"
      version = "latest"
  }
  storage_os_disk {
      name = "webserver-osdisk"
      caching = "ReadWrite"
      create_option = "FromImage"
      managed_disk_type = "Standard_LRS"
  }
  os_profile {
      computer_name = "webserver"
      admin_username = "ubuntu"
  }
  os_profile_linux_config {
      disable_password_authentication = true
      ssh_keys {
          key_data = "${var.ssh_key_str}"
          path = "/home/ubuntu/.ssh/authorized_keys"
      }
  }
  boot_diagnostics {
      enabled = true
      storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
  }
  tags = {
      environment = "${var.tag}"
  }
}


resource "azurerm_virtual_machine" "appserver" {
  name = "appserver"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  location = "${var.location}"
  vm_size = "Standard_B1s"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true
  network_interface_ids = ["${azurerm_network_interface.appservernic.id}"]
  storage_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "18.04-LTS"
      version = "latest"
  }
  storage_os_disk {
      name = "appserver-osdisk"
      caching = "ReadWrite"
      create_option = "FromImage"
      managed_disk_type = "Standard_LRS"
  }
  os_profile {
      computer_name = "appserver"
      admin_username = "ubuntu"
      admin_password = "ubu_18+4"
  }
  os_profile_linux_config {
      disable_password_authentication = false
  }
  boot_diagnostics {
      enabled = true
      storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
  }
  tags = {
      environment = "${var.tag}"
  }
}

resource "azurerm_virtual_machine" "dbserver" {
  name = "dbserver"
  resource_group_name = "${azurerm_resource_group.terrarg.name}"
  location = "${var.location}"
  vm_size = "Standard_B1s"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true
  network_interface_ids = ["${azurerm_network_interface.dbservernic.id}"]
  storage_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "18.04-LTS"
      version = "latest"
  }
  storage_os_disk {
      name = "dbserver-osdisk"
      create_option = "FromImage"
      caching = "ReadWrite"
      managed_disk_type = "Standard_LRS"
  }
  os_profile {
      computer_name = "dbserver"
      admin_username = "ubuntu"
      admin_password = "ubu_18+4"
  }
  os_profile_linux_config {
      disable_password_authentication = false
  }
  boot_diagnostics {
      enabled = true
      storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
  }
}
