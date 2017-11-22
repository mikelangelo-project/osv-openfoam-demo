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

IMAGESERVER_POD="${1:-imageserver-pod-id}"

function fun::compose_and_upload {
  echo "Composing and uploading openfoam unikernel"
  capstan package compose openfoam --size=1GB --pull-missing

  echo "Copying to ---image-server---"
  kubectl cp "$HOME/.capstan/repository/openfoam/openfoam.qemu" "kube-system/$IMAGESERVER_POD:/usr/share/nginx/html/"
}

#
# Main
#

fun::compose_and_upload
