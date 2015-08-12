Add-PSSnapin "Microsoft.SharePoint.Powershell"

$WEBAPP = Read-Host "Enter the site collection URL where the solution will be deployed"

Write-Host "Installing Accusoft.PCC.wsp"
Add-SPSolution $PSScriptRoot\Accusoft.PCC.wsp
Install-SPSolution Accusoft.PCC.wsp -GACDeployment -Force -WebApplication $WEBAPP

Write-Host "Enabling Feature"
Enable-SPFeature "Accusoft.PCC" -URL $WEBAPP -ErrorAction SilentlyContinue

Read-Host -Prompt "Script completed.  Press Enter to exit."