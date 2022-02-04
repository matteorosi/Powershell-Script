Remove-Item "C:\_\Windows_Update\" -Recurse -Force -Confirm:$false 
$winVer = [System.Environment]::OSVersion.Version.Major
$kbinstall = get-hotfix | where {$_.HotFixID -Match "KB4023057"}
mkdir C:\_\Windows_Update\packages
Powercfg /x -standby-timeout-ac 0

if ($kbinstall.HotFixID  -eq "KB4023057")
 { 
if ($winVer -eq 10)
     { 
        $webClient = New-Object System.Net.WebClient
        $url = 'https://go.microsoft.com/fwlink/?LinkID=799445'
        $file = "C:\_\Windows_Update\packages\Win10Upgrade.exe"
        $webClient.DownloadFile($url,$file)
        Start-Process -FilePath $file -ArgumentList '/quietinstall /skipeula /auto upgrade /norestart /qn /copylogs C:\_\Windows_Update\packages'
        } 
    
    else 

        {
            echo "this version is not compatible"
        }}
    else
	 { 
			echo "KB4023057 Not Present"
			$a=get-location
			$b=$a.Path+"\PSWindowsUpdate"
			New-Item -Path "C:\Windows\System32\WindowsPowerShell\v1.0\Modules" -Name "PSWindowsUpdate" -ItemType "directory"
			Expand-Archive "PSWindowsUpdate.zip"
			robocopy $b C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate /s /R:5
			Import-Module -Name C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate\PSWindowsUpdate\2.2.0.2\PSWindowsUpdate.psd1
			Get-WindowsUpdate -Install -KBArticleID KB4023057 -AcceptAll -IgnoreReboot
	 }
sleep 10

Remove-Item "C:\_\Windows_Update\" -Recurse -Force -Confirm:$false 
