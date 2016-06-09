#!/bin/sh

set -e

project="$1"
version="$2"

wget https://releases.hashicorp.com/${project}/${version}/${project}_${version}_linux_amd64.zip
wget https://releases.hashicorp.com/${project}/${version}/${project}_${version}_SHA256SUMS
wget https://releases.hashicorp.com/${project}/${version}/${project}_${version}_SHA256SUMS.sig
gpg --batch --verify ${project}_${version}_SHA256SUMS.sig ${project}_${version}_SHA256SUMS
grep ${version}_linux_amd64.zip ${project}_${version}_SHA256SUMS | sha256sum -c
