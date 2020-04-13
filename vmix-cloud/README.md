# Livestream Experiments

## vMix in the cloud

This guide will help install vMix on a virtual cloud machine using Windows Server and Nvidia GPU graphics within GCP.  
Please note that this is also an experiment and its usage in a production environment should be done responsibly and with your own judgement.  
Basic knowledge and setup of the Google Cloud Platform is required.  
Kudos to [VRT/ RTBF](https://www.videosnackbarhub.com/blogposts/tutorial-how-to-set-up-a-cloud-based-high-end-live-remote-multicam-production) for their inspiration of vMix in the cloud (Paperspace).

## Setup Compute Engine

In the base directory of this git, run the following command, filling the uppercase varibles with your own configuration.

```shell
gcloud deployment-manager deployments create DEPLOYMENT_NAME --project PROJECT_ID --config ./vmix-cloud/run.yaml
```

A compute engine of the size configured in [run-base.yaml](run-base.yaml) will be booted, attached to an external GPU accelerator.  
Now connect to the machine using [Google Cloud RDP](https://chrome.google.com/webstore/detail/chrome-rdp-for-google-clo/mpbbnannobiobpnfblimoapbephgifkm) or Microsoft Remote Desktop ([AppStore](https://apps.apple.com/de/app/microsoft-remote-desktop-10/id1295203466?mt=12)).

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

### Install vmix

Go to [vmix.com](https://www.vmix.com/), download and install the latest version.

### Install vMix VLC support

This is not required but useful for playing back streams or video: [vmix.com/vlcdownload](https://www.vmix.com/vlcdownload).

### Setup SRT

[SRT](https://github.com/Haivision/srt) is an open source protocoll that enables low-latency streams through firewalls. Since our Google Cloud VM will come configured with a public IP address and the necessary firewall configuration, we can make use of SRT to provide local playback of the vMIX video feeds.  
Enable vMix output 1 with high bandwidth and encoding in SRT listener mode on port 1935, then enable vMix output 2 with multiview and lower bandwidth and encoding on port 1936. Use ffplay or VLC on local machine to open SRT stream with the VM's public IP address and port 1935 or 1936 to view the video feed. Make sure that latency is set similarly to the vMix settings. You can also use port 1937 for a third output. Other vMix instances can also use the SRT stream as input source.

## Costs

Google Cloud will bill you for the costs of this machine, for example stuff like

- Nvidia Tesla runtime costs plus license fee
- Network Egress (for streaming, SRT, RDP...)
- License fee for Windows 2019 server
- N1 machine costs for core and ram

## License

This project is licensed under the terms of the MIT License.

## Links

- [vMIX](https://www.vmix.com/)
- [vMix on Paperspace](https://www.videosnackbarhub.com/blogposts/tutorial-how-to-set-up-a-cloud-based-high-end-live-remote-multicam-production)
- [GPUs on Virtual Workstations](https://cloud.google.com/compute/docs/gpus#gpu-virtual-workstations)
