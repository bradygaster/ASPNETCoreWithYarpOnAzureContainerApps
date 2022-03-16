[CmdletBinding()]
param (
    [string] $ResourceGroupName = "aspnet-yarp-container-demo-rg",
    [string] $ContainerAppEnvResourceGroupName = $ResourceGroupName,
    [string] $ContainerAppEnvName = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 4.0

$here = Split-Path -Parent $PSCommandPath

$armParams = @{
    useExistingEnv = ($ContainerAppEnvName -ne "")
    envResourceGroup = $ContainerAppEnvResourceGroupName
    envName = $ContainerAppEnvName

    catalog_api_image = "ghcr.io/endjin/aspnetcorewithyarponazurecontainerapps/dotnetoncontainerappsapiscatalog:0.1.0"
    orders_api_image = "ghcr.io/endjin/aspnetcorewithyarponazurecontainerapps/dotnetoncontainerappsapisorders:0.1.0"
    ui_image = "ghcr.io/endjin/aspnetcorewithyarponazurecontainerapps/dotnetoncontainerappsapisui:0.1.0"
    yarp_image = "ghcr.io/endjin/aspnetcorewithyarponazurecontainerapps/dotnetoncontainerappsproxy:0.1.0"
    registry = "ghcr.io"
    registryUsername = ""
    registryPassword = ""
}

New-AzResourceGroup `
    -Name $ResourceGroupName `
    -Location "northeurope" `
    -Verbose `
    -Force

New-AzResourceGroupDeployment `
    -Name "main" `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile "$here/deploy/main.bicep" `
    -TemplateParameterObject $armParams `
    -Verbose