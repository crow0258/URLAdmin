@echo off
pushd %~dp0
powershell.exe -command  " ./urladmin.ps1 restart"
popd
pause