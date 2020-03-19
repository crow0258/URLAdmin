#设置权限
#$action start/restart/reconfig/stop
#仅reconfig,$forePort,$backPort,$ipAddress有效，
#$forePort 前台端口
#$backPort 后台占用端口
#$ipAddress 访问ip地址
param($action,$forePort,$backPort,$ipAddress)
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
#获取根节点
$homePath = (Get-Location).ToString();
#nginx home
$nginxHomePath = Join-Path $homePath "nginx-1.13.5"
#nginx 启动命令
$nginxPath = Join-Path $nginxHomePath "nginx.exe";

#nginx config 配置文件
$nginxConfigPath = Join-Path $nginxHomePath "conf\nginx.conf";
$nginxConfigTmpPath = Join-Path $nginxHomePath "conf\nginx.conf.tmp";

#$javaHomePath = Join-Path $homePath "jdk1.8.0_91"
#$javaExePath = Join-Path $javaHomePath "bin/java.exe"
#java运行程序根目录,此java已经转换为了exe文件
$appPath  =  Join-Path $homePath "app";
$appExePath = Join-Path $appPath "urladminapp.exe";
#$appLogPath  =  Join-Path $appPath "log/console.log";
#$appErrorPath  =  Join-Path $appPath "log/error.log";
#java config 配置文件
$appConfigPath = Join-Path $appPath "applicatio.properties";
$appConfigTmpPath = Join-Path $appPath "applicatio.properties.tmp";

#web config 配置文件
$webPath  =  Join-Path $homePath "web";
$webConfigPath = Join-Path $webPath "index.bundle.js";
$webConfigTmpPath = Join-Path $webPath "index.bundle.js.tmp";

#$nginxPath
#$appExePath
$nginxList = Get-Process -name "nginx" -ErrorAction SilentlyContinue | where {$_.path -eq $nginxPath}  | Select-Object id  | ForEach-Object -Process{$_.id}
#$nginxList.Count
if($nginxList.Count -gt 0){
    for($i=0 ; $i -lt $nginxList.Count; $i++){
        $nginxList[$i]
        Stop-Process -ID $nginxList[$i]
    }
}
$javaList = Get-Process -name "urladminapp" -ErrorAction SilentlyContinue | where {$_.path -eq $appExePath}  | Select-Object id  | ForEach-Object -Process{$_.id}
#$javaList.Count
if($javaList.Count -gt 0){
    for($i=0 ; $i -lt $javaList.Count; $i++){
        $javaList[$i]
        Stop-Process -ID $javaList[$i]
    }
}
#$appPath
#$appExePath
#文件查找并替换内容函数
Function replaceFileText($filePath,$searchText,$replaceText){
	$content = Get-Content -Path $filePath
	$newContent = $content -replace $searchText,$replaceText
	$newContent | Set-Content -Path $filePath
	#(type $filePath) -replace ($searchText,$replaceText)| Set-Content -Path $filePath
}

#如果是reconfig参数，则重置输入
if($action -eq "reconfig" ){
    Copy-Item $webConfigTmpPath $webConfigPath 
    Copy-Item $nginxConfigTmpPath $nginxConfigPath 
    Copy-Item $appConfigTmpPath $appConfigPath 
	$ipAndPort = $ipAddress + ":" + $forePort;
	replaceFileText $webConfigPath '%address%' $ipAndPort
	replaceFileText $appConfigPath '%backPort%' $backPort
	replaceFileText $nginxConfigPath '%forePort%' $forePort
	replaceFileText $nginxConfigPath '%backPort%' $backPort
}
#如果不是stop，就重启nginx和java程序
if($action -ne "stop" ){
    Start-Process -FilePath $nginxPath -WorkingDirectory $nginxHomePath -WindowStyle hidden;
    Start-Process -FilePath $appExePath -WorkingDirectory $appPath -WindowStyle hidden;
}

#-ArgumentList '-jar',$appExePath -RedirectStandardOutput $appLogPath -RedirectStandardError $appErrorPath 
