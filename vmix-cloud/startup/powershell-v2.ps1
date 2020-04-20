# Author: Daniel Freytag
# Version: v2

# Start log file
Start-Transcript -Path "C:\startup-$(get-date -f yyyyMMdd-HHmmssd).log" -NoClobber 
Write-Host "Initializing Startup scrip v1"
$Path = $env:TEMP; 


# Set priviliged runtime
# Set-ExecutionPolicy Unrestricted -Force


# Install .NET (3.5)
Install-WindowsFeature Net-Framework-Core
Write-Host "Installed .NET"


# Install Google Chome
Write-Host "Next up Google Chrome..."
$chrome = "chrome_installer.exe";
Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$chrome; 
Start-Process -FilePath $Path\$chrome -Args "/silent /install" -Verb RunAs -Wait; 
Remove-Item $Path\$chrome
Write-Host "Installed Google Chrome"


# Install Nvidia driver
Write-Host "Next up Nvidia..."
$nvidia = "nvidia-grid.exe";
Invoke-WebRequest "https://storage.googleapis.com/nvidia-drivers-us-public/GRID/GRID8.1/426.04_grid_win10_server2016_server2019_64bit_international.exe"  -OutFile $Path\$nvidia;
Start-Process -FilePath $Path\$nvidia -Args "/s /silent /install" -Verb RunAs -Wait; 
Remove-Item $Path\$nvidia
Write-Host "Installed Nvidia"


# Install mvMix
Write-Host "Next up vMix..."
$vmix = "vmix23.exe"
Invoke-WebRequest "http://cdn.vmix.com/download/vmix23.exe" -OutFile $Path\$vmix;
Start-Process -FilePath $Path\$vmix -Args "/silent /install" -Verb RunAs -Wait; 
Remove-Item $Path\$vmix
Write-Host "Installed vMix"


# Install vMix VLC
Write-Host "Next up vMix VLC..."
$vmixvlc = "vlcforvmix3.exe";
Invoke-WebRequest "http://cdn.vmix.com/download/vlcforvmix3.exe" -OutFile $Path\$vmixvlc;
Start-Process -FilePath $Path\$vmixvlc -Args "/silent /install" -Verb RunAs -Wait; 
Remove-Item $Path\$vmixvlc
Write-Host "Installed vMix VLX"


# Enable audio services https://gist.github.com/loonison123/11240676
Write-Host "Next up Audio..."
Get-Service | Where {$_.Name -match "audio"} | format-table -autosize
Get-Service | Where {$_.Name -match "audio"} | start-service
Get-Service | Where {$_.Name -match "audio"} | set-service -StartupType "Automatic"
Get-WmiObject -class win32_service -filter "Name='AudioSrv'"
Write-Host "Installed Audio"


# say goodbye
Write-Host "Installed EVERYTHING" 
