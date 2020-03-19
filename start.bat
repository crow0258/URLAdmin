:: 不输出内容
@echo off
pushd %~dp0
powershell.exe -ExecutionPolicy Unrestricted -command  " ./urladmin.ps1 start"
#powershell.exe -command  " ./urladmin.ps1 start"
popd
pause