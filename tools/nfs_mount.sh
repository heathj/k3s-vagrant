#!/bin/bash

set -euox pipefail

export NFS_SERVER="10.0.4.200"
export NFS_PORT="30049"
export NFS_PATH="/treebeard"
export NFS_MOUNT_POINT="/tmp/treebeard"

mkdir -p ${NFS_MOUNT_POINT}
mount -o ro,vers=4,port=${NFS_PORT} -t nfs ${NFS_SERVER}:${NFS_PATH} ${NFS_MOUNT_POINT}