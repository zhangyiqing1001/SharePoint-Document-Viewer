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
        $finished = $false
        for($i = 1;$i -le 30; $i++)
        {
            if((Get-SPTimerJob $JobFullName) -eq $null)
            {
                $finished = $true
                break
            }
            Write-Host -NoNewLine .
            Start-Sleep -Seconds 1
        }
        if($finished -eq $false)
        {
            Write-Host
            Write-Host
            Write-Host -NoNewLine "Unable to Deploy Feature." -foregroundcolor Red -BackgroundColor Black
        }
    }
}

$WEBAPP = Read-Host "Enter the web application URL where the solution will be deployed"
$error.Clear()
$errorCount = 0

Write-Host
Write-Host "Installing accusoft.pcc.wsp"
try
{
    Add-SPSolution $PSScriptRoot\Accusoft.PCC.wsp -ErrorAction Stop
}
catch [Exception]
{   
    if($_.Exception.GetType().FullName -eq "System.ArgumentException")
    {
        Write-Host
        Write-Host "The solution has already been installed.  Continuing... " -ForegroundColor Red -BackgroundColor Black
    }
    else
    {
        $errorCount = $errorCount + 1
        Write-Host
        Write-Host $_.Exception.GetType().FullName, $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        Write-Host " on Command: $($_.InvocationInfo.Line)" -ForegroundColor Red -BackgroundColor Black
    }
}

if($errorCount -eq 0)
{
    Write-Host
    Write-Host "Deploying Feature" -NoNewline
    try
    {
        Install-SPSolution Accusoft.PCC.wsp -GACDeployment -Force -WebApplication $WEBAPP -ErrorAction Stop
    }    
    catch [Exception]
    {   
        if($_.Exception.GetType().FullName -eq "System.ArgumentException")
        {
            Write-Host
            Write-Host "The solution has already been deployed.  Continuing... " -ForegroundColor Red -BackgroundColor Black
        }
        else
        {
            $errorCount = $errorCount + 1
            Write-Host
            Write-Host
            Write-Host $_.InvocationInfo.Line.Trim() -ForegroundColor Red -BackgroundColor Black
            Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        }
    }  
    
}

if($errorCount -eq 0)
{   
    WaitForJobToFinish("accusoft.pcc.wsp")    
    Write-Host
    Write-Host "Enabling Feature"
    Disable-SPFeature Accusoft.pcc -URL $WEBAPP -ErrorAction SilentlyContinue -Confirm:$false
    
    Enable-SPFeature Accusoft.PCC -Url $WEBAPP -ErrorAction SilentlyContinue -Confirm:$false
    Write-Host
    Write-Host
    Get-SPSolution accusoft.pcc.wsp 
}

# Updating Security Token Service Config to authenticate users over HTTP
$config = (Get-SPSecurityTokenServiceConfig)
$config.AllowOAuthOverHttp = $true
$config.Update()

Write-Host
Read-Host -Prompt "Script completed.  Press Enter to exit."