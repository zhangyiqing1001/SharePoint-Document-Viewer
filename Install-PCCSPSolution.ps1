Add-PSSnapin "Microsoft.SharePoint.Powershell"

#Function that allows the enable-SPFeature to wait until the solution timer job properly finishes.
function WaitForJobToFinish([string]$SolutionFileName)
{ 
    $JobName = "*solution-deployment*$SolutionFileName*"
    $job = Get-SPTimerJob | ?{ $_.Name -like $JobName }
    if ($job -eq $null) 
    {
        Write-Host 'Timer job not found'
    }
    else
    {
        $JobFullName = $job.Name
        
        while ((Get-SPTimerJob $JobFullName) -ne $null) 
        {
            Write-Host -NoNewLine .
            Start-Sleep -Seconds 2
        }
    }
}

$WEBAPP = Read-Host "Enter the site collection URL where the solution will be deployed"

Write-Host "Installing Accusoft.PCC.wsp"
Add-SPSolution $PSScriptRoot\Accusoft.PCC.wsp
Install-SPSolution Accusoft.PCC.wsp -GACDeployment -Force -WebApplication $WEBAPP

Write-Host "Enabling Feature"
WaitForJobToFinish("accusoft.pcc.wsp")
Enable-SPFeature Accusoft.PCC -Url $WEBAPP -ErrorAction SilentlyContinue

#This script allows STS to authenticate users over HTTP.
Write-Host "Updating STS"
$config = (Get-SPSecurityTokenServiceConfig)
$config.AllowOAuthOverHttp = $true
$config.Update()

Read-Host -Prompt "Script completed.  Press Enter to exit."