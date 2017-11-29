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

function askUser {
	msg=$1; shift
	echo
	echo -e "\x1B[92m${msg} \x1B[39m $*" >&2
	echo "Press Enter to continue or Ctrl-C to stop or type 'n' to skip step" >&2
	read answer
	if [[ $answer == "n" ]]; then
		return 1
	fi
	return 0
}

driverPod=
function driverDo {
	if [[ ! ${driverPod} ]]; then
		driverPod=$(kubectl get pods --selector case=openfoam-driver -o go-template --template '{{range .items}}{{.metadata.name}}{{end}}')
	fi
	if [[ ! ${driverPod} ]]; then
		echo "Could not find container 'openfoam-driver' on Kubernetes. Is it deployed?"; exit 1
	fi
	kubectl exec -it ${driverPod} -- /bin/bash -lc "$@"
}

function waitWorkers {
	numCpus=1
	numDone=0
	while [[ $numDone < $numCpus ]]; do
	        echo "Waiting workers..."
	        numCpus=`driverDo 'tree -L 2 /case | grep "├── processor" | wc -l'`
	        numDone=`driverDo 'tree -L 2 /case | grep "│   └── 50"    | wc -l'`
	        sleep 2
	done
	echo "Workers are done."
}

if askUser "Clean driver?"; then
	driverDo "rm -rf /case/* || true"
	driverDo "umount /case || true"
fi
if askUser "Mount NFS to /case?"; then
	driverDo "/mikelangelo/mount-case-dir.sh"
fi
if askUser "Download FOAM example data from S3?"; then
	driverDo "/mikelangelo/download-example-data.sh"
fi
if askUser "Decompose FOAM example data for running on multiple threads?"; then
	driverDo "/mikelangelo/decompose.sh"
fi
if askUser "Delegate FOAM calculation to workers?"; then
	driverDo "/mikelangelo/delegate.sh"
fi
waitWorkers
if askUser "Reconstruct FOAM result calculated by workers?"; then
	driverDo "/mikelangelo/reconstruct.sh"
fi
