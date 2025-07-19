#!/bin/bash

# Script to sync local moots-backend directory to oracle-vm
# This pushes your local changes to the remote server

echo "Syncing local changes to oracle-vm..."

rsync -avz --progress \
  --exclude='.git' \
  --exclude='node_modules' \
  --exclude='*.log' \
  --exclude='.env.local' \
  --exclude='dist' \
  --exclude='pocketbase' \
  --exclude='build' \
  ./ oracle-vm:~/moots/

echo "Sync to oracle-vm completed!"
