# event-livestream-relay

This service runs on [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module/issues) to provide a RTMP relay service. The deployment is configured via Deployment Manager on GCP.


## Install

### Prerequisites:
1. Have `gcloud` CLI installed and authenticated
2. Have a GCP project with billing enabled
3. Deployment Manager API needs to be enabled for said project

### Deploy:
From within this working directory run this command 
```shell
gcloud deployment-manager deployments create DEPLOYMENT_NAME --project PROJECT_ID --config ./deploy/run.yaml
```
Replace `DEPLOYMENT_NAME` and `PROJECT_ID` accordingly. The first will also be used to name all created instances.