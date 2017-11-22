# FOAM Worker
This is a root directory for openfoam-worker OSv unikernel that is
meant to be deployed on Kubernetes (with Virtlet runtime installed).

## Deployment
You need to compose the unikernel, inject it on Kubernetes and then deploy it:

```bash
$ compose_and_upload_unikernel <IMAGE_SERVER_POD_ID>
```

Deploy it from project root:

```bash
$ kubectl create -f virtlet_deploy/openfoam-worker.yaml
```

NOTE: When unikernel is deployed, it starts simulation immediately, so please make
sure that simulation data is prepared before that by FOAM Driver (read
[here](../foam_driver/README.md)).

## Usage
Unikernel is configured so that no manual steps are needed once it's deployed. It will
calculate the simulation and then wait forever.
