#!/usr/bin/env bash

echo "========= updating moots-pocketbase.service ======="

# Stop the service first
sudo systemctl stop moots-pocketbase.service

# Overwrite the service file
echo "
[Unit]
Description = moots pocketbase

[Service]
Type           = simple
User           = root
Group          = root
LimitNOFILE    = 4096
Restart        = always
RestartSec     = 5s
StandardOutput   = append:/home/ubuntu/moots/errors.log
StandardError    = append:/home/ubuntu/moots/errors.log
WorkingDirectory = /home/ubuntu/moots/
ExecStart      = /home/ubuntu/moots/pocketbase serve --http=\"127.0.0.1:8094\"

[Install]
WantedBy = multi-user.target
" | sudo tee /lib/systemd/system/moots-pocketbase.service

# Reload systemd and restart the service
sudo systemctl daemon-reload
sudo systemctl start moots-pocketbase.service
sudo systemctl status moots-pocketbase.service

echo "========= moots-pocketbase.service updated successfully! ======="
