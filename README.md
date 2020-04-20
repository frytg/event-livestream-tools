# event-livestream-tools
  
## relay

This service runs on [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) to provide an RTMP relay service. The deployment is automated via Deployment Manager on GCP. It is designed to quickly set it up for events and then trash the project.  
See [relay/README](relay/README.md)

## vMix in the cloud

This guide will install vMix on a virtual cloud machine using Windows Server and Nvidia GPU graphics within GCP.  
See [vmix-cloud/README](vmix-cloud/README.md)

## License

This project is available under the [hippocratic-license](https://github.com/EthicalSource/hippocratic-license); see [LICENSE](LICENSE).

## Links

- Learn about [Deployment Manager](https://cloud.google.com/deployment-manager/docs/how-to)
- Deployment Manager [file samples](https://github.com/GoogleCloudPlatform/deploymentmanager-samples/tree/master/examples/v2)
- GCP docs for [compute.v1.instance](https://cloud.google.com/compute/docs/reference/rest/v1/instances)
