#!/bin/bash

REPO_DIR="${BASH_SOURCE%/*}/../../.."

docker build -t "ue-jenkins-controller:local" "${REPO_DIR}/../UE-Jenkins-Controller"
docker build -t "ue-jenkins-buildtools-linux:local" "${REPO_DIR}/../UE-Jenkins-BuildTools"
