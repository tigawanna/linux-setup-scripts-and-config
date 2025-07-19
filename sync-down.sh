#!/bin/bash

# Script to pull changes from oracle-vm to local moots-backend directory
# Excludes pocketbase file to avoid compatibility issues with local machine

echo "Pulling changes from oracle-vm..."

rsync -avz --progress \
  --exclude='.git' \
  --exclude='node_modules' \
  --exclude='*.log' \
  --exclude='.env.local' \
  --exclude='dist' \
  --exclude='build' \
  oracle-vm:~/moots/ ./

echo "Pull from oracle-vm completed!"

