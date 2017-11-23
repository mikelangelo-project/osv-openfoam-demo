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

FROM openfoamplus/of_v30plus_rhel66

#
# PREPARE ENVIRONMENT
#

RUN yum install -y nfs-utils tree epel-release
RUN yum install -y jq
COPY docker_files /

#
# RUN
#

WORKDIR /mikelangelo
CMD echo "\n--- foam-driver is ready and will now sleep ---\n"; sleep infinity

#
# NOTES
#
# Build this container with:
# docker build -t mikelangelo/openfoam-driver .
#
# Run this container with:
# docker run -it mikelangelo/openfoam-driver /bin/bash
#
# Inject this container with:
# docker save mikelangelo/openfoam-driver | docker exec -i kube-node-1 docker load
# docker save mikelangelo/openfoam-driver | docker exec -i kube-node-2 docker load
#
