Add-PSSnapin "Microsoft.SharePoint.Powershell"

$WOPIHOST = Read-Host "Enter the host name of the PCC WOPI Client site"

Write-Host "Updating PCC WOPI Bindings"

Set-SPWOPIZone -Zone internal-http -ErrorAction SilentlyContinue

$ViewBinding = Get-SPWOPIBinding -Action view
if($ViewBinding -ne $null)
{
    Remove-SPWOPIBinding -Action view -Confirm:$false
}

$PreviewBinding = Get-SPWOPIBinding -Action interactivepreview
if($PreviewBinding -ne $null)
{
    Remove-SPWOPIBinding -Action interactivepreview -Confirm:$false
}

New-SPWOPIBinding -ServerName $WOPIHOST -AllowHTTP

Write-Host "Updating the Interactive Preview list of supported extensions"

if (!(Test-Path -path 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\Prizm')) 
{
    New-Item 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\Prizm' -type directory
}

Get-SPWOPIBinding -Action interactivepreview | Out-File -filepath 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\Prizm\WOPIExtensions.txt' -Force

Read-Host -Prompt "Script completed.  Press Enter to exit."