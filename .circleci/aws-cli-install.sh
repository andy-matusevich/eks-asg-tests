#!/bin/sh -leo pipefail

apk update
apk add --no-cache --update g++ python3-dev py3-pip libffi-dev openssl openssl-dev sudo
echo "Set disable_coredump false" >> /etc/sudo.conf
apk add --no-cache --update curl python3 bash jq
pip3 install --upgrade pip setuptools
pip3 install --upgrade awscli

