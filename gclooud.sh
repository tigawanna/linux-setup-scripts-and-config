#!/bin/bash
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
sudo rm -rf  google-cloud-sdk
sudp rm -rf google-cloud-cli-linux-x86_64.tar.gz
