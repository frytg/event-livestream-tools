# event-livestream-relay

This service runs on [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module/issues) to provide an RTMP relay service. The deployment is automated via Deployment Manager on GCP. It is designed to quickly set it up for events and then trash the project via


## INSTALL

### PREREQUISITES
1. Have `gcloud` CLI installed and authenticated
2. Have a GCP project with billing enabled
3. Deployment Manager API needs to be enabled for said project

### DEPLOY
From within this working directory run this command 
```shell
gcloud deployment-manager deployments create DEPLOYMENT_NAME --project PROJECT_ID --config ./deploy/run.yaml
```
Replace `DEPLOYMENT_NAME` and `PROJECT_ID` accordingly. The first will also be used to name all created instances.

### CLEANUP
As quickly as the service has been deployed, it can also be killed.
```shell
gcloud deployment-manager deployments delete DEPLOYMENT_NAME --project PROJECT_ID
```

## STREAM
Point your encoder towards the final IP or DNS address and start streaming.

### INGEST
```
rtmp://0.0.0.0/live
```
Note: Streaming keys are flexible and not monitored!

### OUTPUT
```
rtmp://0.0.0.0/live/STREAMING_KEY
```


## TODO

- Add programmatic IP and DNS connection


## License

This project is licensed under the terms of the MIT License.