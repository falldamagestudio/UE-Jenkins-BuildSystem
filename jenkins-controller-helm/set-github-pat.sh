#!/bin/bash

GITHUB_PAT=$1

cat github-pat.yaml | sed s/\<password\>/${GITHUB_PAT}/ | kubectl apply -f -