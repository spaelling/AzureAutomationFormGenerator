Import-Module AzureRM

$SubscriptionId = 'bfbe61c4-9252-4b57-86c7-6be19955cea8'

try {
    Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Out-Null
}
catch {
    Login-AzureRmAccount -TenantId '96c09248-727b-4608-8ad9-31997e7ae230'
}

Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Out-Null

$serverFarmResourceGroup = "rg_BRp0th5V".ToLower()
$Location = 'northeurope'

New-AzureRmResourceGroup -Name $serverFarmResourceGroup -Location $Location -Force | Out-Null

New-AzureRmResourceGroupDeployment -Name "deploy_$((Get-Date).ToFileTimeUtc())" -ResourceGroupName $serverFarmResourceGroup `
    -TemplateFile "$PSScriptRoot\azuredeploy.json"

Test-AzureRmResourceGroupDeployment -ResourceGroupName 

#<# cleanup
Get-AzureRmResourceGroup | Remove-AzureRmResourceGroup -AsJob -Force -Verbose | Out-Null
while((Get-AzureRmResourceGroup).Count -gt 0)
{
    Start-Sleep -Seconds 5
}
#>