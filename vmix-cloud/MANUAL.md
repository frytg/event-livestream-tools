# Livestream Experiments

## vMix in the cloud

This page describes the manual process of setting up Windows Server if automatic install upon start doesn't work.

## Setup Microsoft Environment

### Install Google Chrome

This is not required, but will make your life a lot easier, since Microsoft Server ships with Internet Explorer... To install open PowerShell and run this command

```shell
$Path = $env:TEMP; $Installer = "chrome_installer.exe"; Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer; Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait; Remove-Item $Path\$Installer
```

### Enable .NET 3.5

Install .NET 3.5 using either the Control Panel and "Turn Windows features on or off" or run this command

```shell
Install-WindowsFeature Net-Framework-Core -source \\network\share\sxs
```

### Install GPU support

As configured in [deploy-vm.jinja](deploy-vm.jinja) this VM run with an Nvidia Tesla GPU. To enable system support, install the driver from this page:  
[cloud.google.com/compute/docs/gpus/install-grid-drivers](https://cloud.google.com/compute/docs/gpus/install-grid-drivers) -> Windows Server 2019  
Which as of right no is this one: [426.04_grid_win10_server2016_server2019_64bit_international.exe](https://storage.googleapis.com/nvidia-drivers-us-public/GRID/GRID8.1/426.04_grid_win10_server2016_server2019_64bit_international.exe)

### Enable windows audio services

Click on the sound icon and navigate your way to enable audio support. Test this by playing an audio/ video in Google Chrome. You should hear sound via RDP.

### Install vMix

Go to [vmix.com](https://www.vmix.com/), download and install the latest version.

### Install vMix VLC support

This is not required but useful for playing back streams or video: [vmix.com/vlcdownload](https://www.vmix.com/vlcdownload).
