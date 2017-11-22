# OpenFOAM in OSv on Kubernetes
This project demonstrates how one can run OpenFOAM on Kubernetes using OSv unikernels.
Please note that [Virtlet](https://github.com/Mirantis/virtlet) runtime needs to be installed on the
Kubernetes in order to be able to run unikernels there.

## Deploy
First, you need to deploy the NFS server (which is a Docker container actually):

```bash
$ kubectl create -f virtlet_deploy/nfs.yaml
```

Then you can deploy the mikelangelo/openfoam-driver Docker container and prepare the simulation
data with (read [here](./foam_driver/README.md) for exact commands, but basically you need to
connect there via `kubectl exec` and manually execute some commands):

```bash
$ kubectl create -f virtlet_deploy/openfoam-driver.yaml
```

When the simulation data is ready, you can actually run the worker to start calculating:

```bash
$ kubectl create -f virtlet_deploy/openfoam-worker.yaml
```

Last step is simulation result reconstruction (again, read [here](./foam_driver/README.md)).

## License
Unless specifically noted, all parts of this project are licensed under the [Apache 2.0 license](LICENSE).

## Acknowledgements
This code has been developed within the [MIKELANGELO project](https://www.mikelangelo-project.eu)
(no. 645402), started in January 2015, and co-funded by the European Commission under the
H2020-ICT-07-2014: Advanced Cloud Infrastructures and Services programme.
