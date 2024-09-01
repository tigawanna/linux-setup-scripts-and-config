#!/usr/bin/env bash
version = 0.22.20
pocketbase_url = https://github.com/pocketbase/pocketbase/releases/download/v${version}/pocketbase_${version}_darwin_amd64.zip
curl -sL ${pocketbase_url} | tar -zxvC /usr/local/bin
