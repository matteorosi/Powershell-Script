$winVer = [System.Environment]::OSVersion.Version.Major
$dir = 'C:\_\Windows_Update\packages'
mkdir $dir

if ($winVer -eq 10)
    {  
        $webClient = New-Object System.Net.WebClient
        $url = 'https://go.microsoft.com/fwlink/?LinkID=799445'
        $file = "$($dir)\Win10Upgrade.exe"
        $webClient.DownloadFile($url,$file)
        Start-Process -FilePath $file -ArgumentList '/quietinstall /skipeula /auto upgrade /copylogs $dir'
        } 
    
    else 

        {
            echo "This is Not Windows10 OS Compatible"
        }
    
sleep 10

Remove-Item "C:\_\Windows_Update\" -Recurse -Force -Confirm:$false 
