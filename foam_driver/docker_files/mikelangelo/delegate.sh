#!/bin/bash
# Copyright (C) 2017 XLAB, Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

# Complain if decompose wasn't run yet
if [ ! -d "/case/processor0" ]; then echo "You need to decompose the data first. Please run './decompose.sh'"; exit 1; fi

# Obtain IPs of all OSv workers (Pods labeled with "case=openfoam-worker")
kubernetesUrl=${1:-10.192.0.2:8080}
workersList=$(curl --silent http://${kubernetesUrl}/api/v1/namespaces/default/pods?labelSelector=case%3Dopenfoam-worker | jq .items[].status.podIP)
workersList=$(echo ${workersList} | sed s/"\""/""/g | sed s/" "/","/g)

# Extract "numberOfSubdomains" value from /case/system/decomposeParDict
parallelisation=$(sed -n '/^numberOfSubdomains .*;/p' < /case/system/decomposeParDict | sed 's/^numberOfSubdomains \([0-9]*\);/\1/')

# Run the simulation
echo "Delegating FOAM work"
echo " -> workers: ${workersList}"
echo " -> parallelisation: ${parallelisation}"
curl \
  -X \
  PUT \
  -d command="/usr/bin/mpirun -n ${parallelisation} -H ${workersList} --allow-run-as-root /usr/bin/simpleFoam.so -parallel -case /case" \
  openfoam-worker.default:8000/app/
