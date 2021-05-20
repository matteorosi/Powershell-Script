Get-Content \\Path.list-machine.txt | Foreach-Object{
    
    # open a new PS remote sessione
    $session = New-PSSession $_

    if ($session -is [System.Management.Automation.Runspaces.PSSession])
        {
        # session correctly opened
        Write-Host
        Write-Host "**************************************************"
        Write-Host "Remote session successfully created: $_"
		
		# create Driver folder
        Invoke-Command -Session $session -ScriptBlock {New-Item -Path 'c:\drivers' -ItemType Directory}
		# copy driver folder content from shared folder
        Copy-Item "\\Betwork-Path\driver*" -ToSession $session "C:\drivers" -recurse -force
		
Get-ChildItem "C:\drivers\" -Recurse -Filter "*.inf" | 
ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install }

        # close remote session
        Remove-PSSession -Session $session
        }
    else
        {
        Write-Host
        Write-Host "**************************************************"
        Write-Host "Remote session failed: $_"
        }
} 

