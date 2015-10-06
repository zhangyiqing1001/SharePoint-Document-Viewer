Add-PSSnapin "Microsoft.SharePoint.Powershell"

Write-Host "Removing PCC WOPI Bindings"

Get-SPWOPIBinding -Application PCC | Remove-SPWOPIBinding -Confirm:$false

Write-Host
Read-Host -Prompt "Script completed.  Press Enter to exit."