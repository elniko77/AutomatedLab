$labName = 'SmallClient2'

#create an empty lab template and define where the lab XML files and the VMs will be stored
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

#make the network definition
Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace 192.168.83.0/24

Add-LabIsoImageDefinition -Name SQLServer2014 -Path $labSources\ISOs\SW_DVD9_SQL_Svr_Standard_Edtn_2014w_SP3_64Bit_English_MVLS_MLF_X21-70221.ISO

#defining default parameter values, as these ones are the same for all the machines
$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:DomainName' = 'test2.net'
    'Add-LabMachineDefinition:Memory' = 1GB
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2012 Standard (Server with a GUI)'
}

Set-LabInstallationCredential -Username Install -Password Somepass1
#and the domain definition with the domain admin account
Add-LabDomainDefinition -Name test2.net -AdminUser Install -AdminPassword Somepass1

Add-LabMachineDefinition -Name DC1 -Roles RootDC
Add-LabMachineDefinition -Name SQL1 -Roles SQLServer2014

Install-Lab

Show-LabDeploymentSummary -Detailed