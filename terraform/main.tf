# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = "6a3062de-147e-4aac-861f-11edefd358f6"
  client_secret   = "z6E8Q~P5h8g2ENS8poSgFwVw0GXRi3pq2ZQGDa1a"
  subscription_id = "467e30b8-c0a9-467e-b41d-cfa0d7901e61"
  tenant_id       = "7d1ff467-2332-43e1-88f3-fefdff0c31f7"
}

resource "azurerm_resource_group" "TestRG" {
  name     = "githubRG"
  location = "East US"
}

resource "azurerm_virtual_network" "TestVnet" {
  name                = "github-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.TestRG.location
  resource_group_name = azurerm_resource_group.TestRG.name
}

resource "azurerm_subnet" "Testsubnet" {
  name                 = "Githubsubnet"
  resource_group_name  = azurerm_resource_group.TestRG.name
  virtual_network_name = azurerm_virtual_network.TestVnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "TestNIC" {
  name                = "example-nic"
  location            = azurerm_resource_group.TestRG.location
  resource_group_name = azurerm_resource_group.TestRG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Testsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "TestVM" {
  name                = "githubVM"
  resource_group_name = azurerm_resource_group.TestRG.name
  location            = azurerm_resource_group.TestRG.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.TestNIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}