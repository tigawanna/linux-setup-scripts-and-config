#!/usr/bin/env bash
#  for oracle ampere
version="0.22.20"
pocketbase_url="https://github.com/pocketbase/pocketbase/releases/download/v${version}/pocketbase_${version}_linux_amd64.zip"

echo "========= downloading pocketbase version ${version} ======="
wget -q - "$pocketbase_url"
echo "========= unzipping pocketbase version ${version} ======="
sudo apt install zip -y
sudo unzip -q pocketbase_${version}_linux_amd64.zip -d /home/ubuntu/pb
sudo chmod +x /home/ubuntu/pb/pocketbase
echo "========= pocketbase version ${version} has been downloaded and unzipped into /home/ubuntu/pb successfully! ======="
sudo rm -rf pocketbase_${version}_inux_amd64.zip
echo "========= setting up a systemd service ======= "
# setup a systemd service service
sudo touch /lib/systemd/system/pocketbase.service
echo "
[Unit]
Description = pocketbase

[Service]
Type           = simple
User           = root
Group          = root
LimitNOFILE    = 4096
Restart        = always
RestartSec     = 5s
StandardOutput   = append:/home/ubuntu/pb/errors.log
StandardError    = append:/home/ubuntu/pb/errors.log
WorkingDirectory = /home/ubuntu/pb/
ExecStart      = /home/ubuntu/pb/pocketbase serve

[Install]
WantedBy = multi-user.target
" | sudo tee /lib/systemd/system/pocketbase.service


sudo systemctl daemon-reload
sudo systemctl enable pocketbase.service
sudo systemctl start pocketbase
