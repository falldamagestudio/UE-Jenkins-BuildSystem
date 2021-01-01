#!/bin/bash

docker build -t "jenkins:local" ../../UE-Jenkins-Controller
docker build -t "ue-jenkins-buildtools-linux:local" ../../UE-Jenkins-BuildTools
