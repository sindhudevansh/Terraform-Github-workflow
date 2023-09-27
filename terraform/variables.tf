# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = "1.5.6"
}

provider "azurerm" {
  features {}
}

variable "resource_group" {
    default = "Test-RG2"
}

variable "location" {
    default = "West Europe"
}

variable "vnet" {
    default = "Test-Vnet2"
}

variable "address_space" {
    default = "10.0.0.0/16"
}

variable "network_security_group" {
    default = "Test-Nsg2"
}

variable "subnet_name" {
    type        = string
    default     = "subnet"
}

variable "subnet_prefix" {
    description = "List of subnet CIDR prefixes"
    type        = string
    default     = "10.0.0.0/24"
}

variable "publicip" {
    default = "Test-publicip2"
}

variable "network-interface" {
    default = "Test-network-interface2"
}

variable "ipname" {
    default = "Testinternal"
}

variable "virtual-machine" {
    default = "Test-virtualmachine"
}

variable "vm-size" {
    type = string
    default     = "Standard_DS2_v2"
}

variable "osdisk" {
    default = "Test-osdisk"
}

variable "computername" {
    default = "TestVirtualMachine"
}

variable "username" {
    default = "adminuser"
}

variable "password" {
    default = "Pachi@#321"
}

variable "storage-image-reference" {
  description = "Source image reference for the virtual machine"
  type        = string
  default     = "latest"  
}

variable "source_image_publisher" {
  description = "Publisher of the source image"
  type        = string
  default     = "Canonical"
}

variable "source_image_offer" {
  description = "Offer of the source image"
  type        = string
  default     = "UbuntuServer"
}

variable "source_image_sku" {
  description = "SKU of the source image"
  type        = string
  default     = "18.04-LTS"
}

variable "source_image_version" {
  description = "Version of the source image"
  type        = string
  default     = "latest"
}