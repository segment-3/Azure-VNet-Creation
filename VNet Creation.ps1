$rg = @{
    Name = ‘Module03AR’
    Location = 'eastus2'
}
New-AzResourceGroup @rg
$vnet = @{
    Name = 'vnet-1'
    ResourceGroupName = ‘Module03AR’
    Location = 'eastus2'
    AddressPrefix = '10.0.0.0/16'
}
$virtualNetwork = New-AzVirtualNetwork @vnet
$subnet = @{
    Name = 'subnet-1'
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '10.0.0.0/24'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet
$virtualNetwork | Set-AzVirtualNetwork
$subnet = @{
    Name = 'AzureBastionSubnet'
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '10.0.1.0/26'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet
$virtualNetwork | Set-AzVirtualNetwork
$ip = @{
        ResourceGroupName = ‘Module03AR’
        Name = 'public-ip'
        Location = 'eastus2'
        AllocationMethod = 'Static'
        Sku = 'Standard'
        Zone = 1,2,3
}
New-AzPublicIpAddress @ip
$bastion = @{
    Name = 'bastion'
    ResourceGroupName = ‘Module03AR’
    PublicIpAddressRgName = ‘Module03AR’
    PublicIpAddressName = 'public-ip'
    VirtualNetworkRgName = ‘Module03AR’
    VirtualNetworkName = 'vnet-1'
    Sku = 'Basic'
}
New-AzBastion @bastion
# Set the administrator and password for the VMs. ##
$cred = Get-Credential

## Place the virtual network into a variable. ##
$vnet = Get-AzVirtualNetwork -Name 'vnet-1' -ResourceGroupName ‘Module03AR’

## Create network interface for virtual machine. ##
$nic = @{
    Name = "nic-1"
    ResourceGroupName = ‘Module03AR’
    Location = 'eastus2'
    Subnet = $vnet.Subnets[0]
}
$nicVM = New-AzNetworkInterface @nic

## Create a virtual machine configuration for VMs ##
$vmsz = @{
    VMName = "vm-1"
    VMSize = 'Standard_DS1_v2'  
}
$vmos = @{
    ComputerName = "vm-1"
    Credential = $cred
}
$vmimage = @{
    PublisherName = 'Canonical'
    Offer = '0001-com-ubuntu-server-jammy'
    Skus = '22_04-lts-gen2'
    Version = 'latest'    
}
$vmConfig = New-AzVMConfig @vmsz `
    | Set-AzVMOperatingSystem @vmos -Linux `
    | Set-AzVMSourceImage @vmimage `
    | Add-AzVMNetworkInterface -Id $nicVM.Id

## Create the virtual machine for VMs ##
$vm = @{
    ResourceGroupName = ‘Module03AR’
    Location = 'eastus2'
    VM = $vmConfig
}
New-AzVM @vm
# Set the administrator and password for the VMs. ##
$cred = Get-Credential

## Place the virtual network into a variable. ##
$vnet = Get-AzVirtualNetwork -Name 'vnet-1' -ResourceGroupName ‘Module03AR’

## Create network interface for virtual machine. ##
$nic = @{
    Name = "nic-2"
    ResourceGroupName = ‘Module03AR’
    Location = 'eastus2'
    Subnet = $vnet.Subnets[0]
}
$nicVM = New-AzNetworkInterface @nic

## Create a virtual machine configuration for VMs ##
$vmsz = @{
    VMName = "vm-2"
    VMSize = 'Standard_DS1_v2'  
}
$vmos = @{
    ComputerName = "vm-2"
    Credential = $cred
}
$vmimage = @{
    PublisherName = 'Canonical'
    Offer = '0001-com-ubuntu-server-jammy'
    Skus = '22_04-lts-gen2'
    Version = 'latest'    
}
$vmConfig = New-AzVMConfig @vmsz `
    | Set-AzVMOperatingSystem @vmos -Linux `
    | Set-AzVMSourceImage @vmimage `
    | Add-AzVMNetworkInterface -Id $nicVM.Id

## Create the virtual machine for VMs ##
$vm = @{
    ResourceGroupName = ‘Module03AR’
    Location = 'eastus2'
    VM = $vmConfig
}
New-AzVM @vm

