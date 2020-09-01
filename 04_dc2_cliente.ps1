# Ejemplo de dominio, con 2 dc y un cliente w10


$labName = 'SmallClient2'

#create an empty lab template and define where the lab XML files and the VMs will be stored
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

#make the network definition
Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace 192.168.85.0/24

Set-LabInstallationCredential -Username Install -Password Somepass1

#and the domain definition with the domain admin account
Add-LabDomainDefinition -Name test2.net -AdminUser Install -AdminPassword Somepass1

#the first machine is the root domain controller. Everything in $labSources\Tools get copied to the machine's Windows folder
Add-LabMachineDefinition -Name S3DC1 -Memory 512MB -Network $labName -DomainName test2.net -Roles RootDC `
    -ToolsPath $labSources\Tools -OperatingSystem 'Windows Server 2019 Standard (Desktop Experience)'

#the root domain gets a second domain controller
$roles = Get-LabMachineRoleDefinition -Role DC
Add-LabMachineDefinition -Name S3DC2 -DomainName test2.net -Roles $roles -ToolsPath $labSources\Tools -OperatingSystem 'Windows Server 2016 Standard (Desktop Experience)'


#the second just a member client. Everything in $labSources\Tools get copied to the machine's Windows folder
Add-LabMachineDefinition -Name S3Client1 -Memory 512MB -Network $labName `
    -DomainName test2.net -ToolsPath $labSources\Tools -OperatingSystem 'Windows 10 Pro'

Install-Lab

Show-LabDeploymentSummary -Detailed