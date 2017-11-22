# FOAM Driver
This is a root directory for mikelangelo/openfoam-driver Docker container that is
meant to be deployed on Kubernetes. It contains following software:

* OpenFOAM installation
* NFS-client installation
* Demo scripts (in /mikelangelo direcotry)

## Deployment
You need to build the container, inject it on Kubernetes and then deploy it:

```bash
$ docker build -t mikelangelo/openfoam-driver .
$ docker save mikelangelo/openfoam-driver | docker exec -i kube-node-1 docker load
$ docker save mikelangelo/openfoam-driver | docker exec -i kube-node-2 docker load
```

Deploy it from project root:

```bash
$ kubectl create -f virtlet_deploy/openfoam-driver.yaml
```

## Usage
Once the container is deployed on Kubernetes, please connect to it by using:

```bash
$ kubectl exec -it <POD_ID> -- /bin/bash
```

Following steps are then required in order to run SimpleFOAM simulation:

### Step 1 - Prepare Case

```bash
$ ./mount-case-dir.sh <NFS_IP>
$ ./download-example-data.sh
```

The first command above will mount NFS directory to container's `/case` while the second command will
fill it with some simple OpenFOAM simulation data. Having the data in place, you can prepare it for the
actual simulation:

```bash
$ ./decompose.sh
```

### Step 2 - Run the Simulation
Simulation is run on openfoam-worker OSv unikernels. Please read [here](../foam_worker/README.md) for
more information.

### Step 3 - Reconstruct the Results
When OSv workers are done running the simulation, the result fragments need to be combined into a single
final result. Use following command to do this:

```bash
$ ./reconstruct.sh
```

Viola! The final result waits for you in `/case/100` directory.
