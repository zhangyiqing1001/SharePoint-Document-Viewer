Add-PSSnapin "Microsoft.SharePoint.Powershell"

$WOPIHOST = Read-Host "Enter the host name of the PCC WOPI Client site"

Write-Host "Updating PCC WOPI Bindings"
Set-SPWOPIZone -Zone internal-http -ErrorAction SilentlyContinue
Remove-SPWOPIBinding -Action view -Confirm:$false -ErrorAction SilentlyContinue
Remove-SPWOPIBinding -Action interactivepreview -Confirm:$false -ErrorAction SilentlyContinue
New-SPWOPIBinding -ServerName $WOPIHOST -AllowHTTP

Write-Host "Updating Interactive Preview list of supported extensions"
if (!(Test-Path -path 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\Prizm')) 
{
    New-Item 'D:Data' -type directory
}
Get-SPWOPIBinding -Action interactivepreview | Out-File -filepath 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\Prizm\WOPIExtensions.txt' -Force

Read-Host -Prompt "Script completed.  Press Enter to exit."