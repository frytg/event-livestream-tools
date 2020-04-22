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

### Compute machine types

There are plenty of machine types on Google Cloud platform, GPUs are primarily supported on N1 machines. See [available regions and zones](https://cloud.google.com/compute/docs/regions-zones/?hl=en_US#available) for the full list.

### GPUs

The GPUs are only available in several zones. Check ["NVIDIA® GRID® GPUs for graphics workloads"](https://cloud.google.com/compute/docs/gpus#gpu-virtual-workstations) for the up-to-date mapping. Make sure the quota in your project permits the desired configuration (Cloud Console -> IAM & Admin -> Quoatas).

### Quotas

Speaking of quotas, they can be the bottleneck once your cloud project is initiallly created. There are limits on all aspects such as CPU, RAM, Disks, GPUs, etc. The critical part can be the "_Compute Engine API NVIDIA T4 Virtual Workstation GPUs_" limit, which is low in the beginning but can be increasing via a support request (may take time or can be rejected).

## Setup Microsoft Environment

### Setup dependencies

The server should automatically install .NET, vMIX and other dependencies via Powershell. See [MANUAL.md](MANUAL.md) for all manual steps.  
You should be able to find a lof file like `startup-DATETIME.log` in the root folder of the `C:\` drive. Please set your `startupScriptUrl` in [run.yaml](run.yaml) since not every project might have access to `gs://event-livestream-tools/` (Sync new files via `gsutil cp -r ./vmix-cloud/startup/ gs://event-livestream-tools/vmix-cloud/`).

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

This project is available under the [hippocratic-license](https://github.com/EthicalSource/hippocratic-license); see [LICENSE](../LICENSE).

## Links

- [vMix](https://www.vmix.com/)
- [vMix on Paperspace](https://www.videosnackbarhub.com/blogposts/tutorial-how-to-set-up-a-cloud-based-high-end-live-remote-multicam-production)
- [GPUs on Virtual Workstations](https://cloud.google.com/compute/docs/gpus#gpu-virtual-workstations)
- [Startup scripts for GCP VM](https://cloud.google.com/compute/docs/startupscript)
