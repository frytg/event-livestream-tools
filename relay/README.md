# event-livestream-relay
  
![docker-push](https://github.com/frytg/event-livestream-relay/workflows/docker-push/badge.svg?branch=master)
  
This service runs on [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) to provide an RTMP relay service. The deployment is automated via Deployment Manager on GCP. It is designed to quickly set it up for events and then trash the project via

## INSTALL

### PREREQUISITES

1. Have `gcloud` CLI installed and authenticated
2. Have a GCP project with billing enabled
3. Deployment Manager API needs to be enabled for said project

### DEPLOY

In the base directory of this git, run the following command:

```shell
gcloud deployment-manager deployments create DEPLOYMENT_NAME --project PROJECT_ID --config ./relay/run-base.yaml
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

```shell
rtmp://SERVER_IP/live
```

Note: Streaming keys are flexible and not monitored!

### OUTPUT

```shell
rtmp://SERVER_IP/live/STREAMING_KEY
```

### CONTROL

```shell
http://SERVER_IP:8080/control/record/stop?app=encoder-ingest&name=stream1&rec=rec1
```

## TODO

- Add programmatic IP and DNS connection

## LICENSE

This project is licensed under the terms of the MIT License.

## LINKS

- Learn about [Deployment Manager](https://cloud.google.com/deployment-manager/docs/how-to)
- Deployment Manager [file samples](https://github.com/GoogleCloudPlatform/deploymentmanager-samples/tree/master/examples/v2)
- GCP docs for [compute.v1.instance](https://cloud.google.com/compute/docs/reference/rest/v1/instances)
- The [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) on Github
- FFMPEG encoding options for [H264](https://trac.ffmpeg.org/wiki/Encode/H.264)
- FFMPEG encoding [codecs and flags](https://www.ffmpeg.org/ffmpeg-codecs.html)
