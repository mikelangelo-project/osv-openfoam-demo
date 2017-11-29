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

driverDo "watch -n2 tree -L 2 /case"
