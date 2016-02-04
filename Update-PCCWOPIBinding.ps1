Add-PSSnapin "Microsoft.SharePoint.Powershell"

function SetupPersistedObjects($providerUrl)
{
 #Load the assembly
 [System.Reflection.Assembly]::LoadWithPartialName("Accusoft.Prizm.SharePoint") | Out-Null

 #create a new RenditionConfig Object
 [Accusoft.Prizm.SharePoint.Core.Config.RenditionConfig] $config = [Accusoft.Prizm.SharePoint.RenditionConfig]::EnsureInstance()

 #Insert the new values.
 $config.ProviderUrl = $providerUrl
 $wopiExtensions = Get-SPWOPIBinding -Action interactivepreview
 $config.WopiExtensions = Out-String -InputObject $wopiExtensions


 #Update the persisted Object.
 $config.Update();
 
 Write-Host "Config Data Updated"
}

$WOPIHOST = Read-Host "Enter the host name of the PCC WOPI Client site"
$SSL = Read-Host "Will the connection be using SSL?  Type [Y] or yes if the connection will be SSL.  
Type [N] or No if the connection will be HTTP.  (Default is No)"

Write-Host "Updating PCC WOPI Bindings"


if($SSL.ToLower() -eq "y" -or $SSL.ToLower() -eq "yes") 
{
    Set-SPWOPIZone -Zone internal-https -ErrorAction SilentlyContinue
}
else
{
    Set-SPWOPIZone -Zone internal-http -ErrorAction SilentlyContinue
}

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

if($SSL.ToLower() -eq "y" -or $SSL.ToLower() -eq "yes") 
{
    New-SPWOPIBinding -ServerName $WOPIHOST
}
else
{
    New-SPWOPIBinding -ServerName $WOPIHOST -AllowHTTP
}

Write-Host "Updating the Interactive Preview list of supported extensions"
Write-Host
$WOPIURL = $WOPIHOST
if($SSL.ToLower() -eq "y" -or $SSL.ToLower() -eq "yes") 
{
    $WOPIURL = "https://" + $WOPIHOST
}
else
{
    $WOPIURL = "http://" + $WOPIHOST
}


SetupPersistedObjects $WOPIURL

Write-Host
Get-SPWOPIBinding -Action interactivepreview | Out-File -filepath 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\Prizm\WOPIExtensions.txt' -Force

Read-Host -Prompt "Script completed.  Press Enter to exit."