resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.network_security_group}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["${var.address_space}"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_public_ip" publicip {
  name                = "${var.publicip}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" nic {
  name                = "${var.network-interface}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.ipname}"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation  = "Dynamic"
  }
}

resource "azurerm_virtual_machine" vm {
  name                = "${var.virtual-machine}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  vm_size             = "${var.vm-size}"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  storage_image_reference {
    publisher = "${var.source_image_publisher}"
    offer     = "${var.source_image_offer}"
    sku       = "${var.source_image_sku}"
    version   = "${var.source_image_version}"
  }

  storage_os_disk {
    name              = "${var.osdisk}"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.computername}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}