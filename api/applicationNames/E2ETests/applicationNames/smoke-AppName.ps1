[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$here = Split-Path -Path $MyInvocation.MyCommand.Path
Remove-Module RestAPI
Import-Module ..\RestAPI.psm1
Import-Module Pester

$environment = "dev"
# Url to function
$BaseUrl = ''
# base query string components like authKey. 
$BaseQueryString = ''

Set-ApiBaseUrl -Url $BaseUrl
Set-ApiBaseQueryString -QueryString $BaseQueryString

..\invoke-Pester.ps1 -environment $environment -testPath "$here\*.Tests.ps1"