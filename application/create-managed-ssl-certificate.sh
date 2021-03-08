#!/bin/bash

HOSTNAME=$1

cat managed-ssl-certificate.yaml | sed s/\<domain-name\>/${HOSTNAME}/ | kubectl apply -f -