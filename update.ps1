param(
    [string]$InstallDir,
    [bool]$DeleteSelf=$true
)
if($InstallDir -eq ""){
    Write-Output 参数错误
    exit
}
function CheckProcessRunning ([string]$Name){
    Get-Process $Name -ErrorVariable gpe -ErrorAction SilentlyContinue | Out-Null
    return (([string]$gpe) -eq "")
}
$self=$MyInvocation.MyCommand.Definition
$current=(Split-Path $self)

# echo $PSScript
# $MyInvocation.MyCommand.Definition
# if(-not ([Security.Principal.WindowsPrincipal] `
# [Security.Principal.WindowsIdentity]::GetCurrent() `
# ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
#     Start-Process powershell $MyInvocation.MyCommand.Definition -verb runAs
# }
if((CheckProcessRunning("ScreenHelper"))){
    Write-Output 请关闭ScreenHelper
    Wait-Process ScreenHelper
}
Write-Output 正在更新...
Remove-Item ($InstallDir+"\*") -Force -Recurse
Copy-Item -Path ($current+"\*") -Destination $InstallDir -Exclude (Split-Path $self -Leaf) -Force -Recurse
if($DeleteSelf){
    Remove-Item ($current) -Force -Recurse
}
Write-Output 更新完成
Pause