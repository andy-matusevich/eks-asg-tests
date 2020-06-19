#!/bin/sh -leo pipefail

apk add --no-cache --update .build-deps g++ python3-dev libffi-dev openssl-dev curl sudo
echo "Set disable_coredump false" >> /etc/sudo.conf
apk add --no-cache --update python3
pip3 install --upgrade pip setuptools
pip3 install awscli --upgrade