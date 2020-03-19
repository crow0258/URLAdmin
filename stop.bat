:: 不输出内容
@echo off
:: 批处理设置到当前路径 d drive/ p path / %0 批处理文件所在位置
pushd %~dp0
:: 调用powershell
powershell.exe -command  " ./urladmin.ps1 stop"
popd
pause