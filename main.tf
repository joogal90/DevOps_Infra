resource "azurerm_resource_group" "ACE_RG" {
  name     = local.resource_group_name
  location = local.location
}


resource "azurerm_public_ip" "ACE_PublicIP" {
  name                = "ACE-PublicIP"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.ACE_RG ]

}

resource "azurerm_network_security_group" "NSG" {
  name                = "ACE-NSG"
  location            = local.location
  resource_group_name = local.resource_group_name
}

resource "azurerm_virtual_network" "ACE_VNET" {
  name                = "ACE-VNET"
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  depends_on          = [azurerm_resource_group.ACE_RG]

}


resource "azurerm_subnet" "ACE_Subnet" {
  name                 = "ACE-Subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.ACE_VNET.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.ACE_VNET] 
}


resource "azurerm_network_interface" "ACE_NIC" {
  name                = "ACE-NIC"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ACE_Subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ACE_PublicIP.id
  }
    depends_on = [azurerm_subnet.ACE_Subnet]
}

resource "azurerm_windows_virtual_machine" "ACE_VM" {
  name                = "ACE-VM"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.ACE_NIC.id,
  ]

  depends_on = [ azurerm_network_interface.ACE_NIC]
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

