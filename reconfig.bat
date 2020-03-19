:: 不输出内容
@echo off
pushd %~dp0
set /p forePort="Please enter foreground port:"
set /p backPort="Please enter background port:"
set /p ipAddress="Please enter ip address:"
powershell.exe -command  "./urladmin.ps1 reconfig %forePort% %backPort% %ipAddress%"
popd
pause