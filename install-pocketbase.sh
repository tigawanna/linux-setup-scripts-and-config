#!/usr/bin/env bash
#  for oracle ampere
project_name="moots"
port="8094"
version="0.28.4"
pocketbase_url="https://github.com/pocketbase/pocketbase/releases/download/v${version}/pocketbase_${version}_linux_amd64.zip"

echo "========= downloading pocketbase version ${version} ======="
wget -q "$pocketbase_url"
echo "========= unzipping pocketbase version ${version} ======="

sudo apt install zip -y
sudo mkdir -p /home/ubuntu/${project_name}

sudo unzip -q pocketbase_${version}_linux_amd64.zip -d /home/ubuntu/${project_name}

sudo chmod +x /home/ubuntu/${project_name}/pocketbase
echo "========= pocketbase version ${version} has been downloaded and unzipped into /home/ubuntu/${project_name} successfully! ======="

sudo rm -rf pocketbase_${version}_linux_amd64.zip

echo "========= setting up a systemd service ======= "
# setup a systemd service service
sudo touch /lib/systemd/system/${project_name}-pocketbase.service
echo "
[Unit]
Description = ${project_name} pocketbase

[Service]
Type           = simple
User           = root
Group          = root
LimitNOFILE    = 4096
Restart        = always
RestartSec     = 5s
StandardOutput   = append:/home/ubuntu/${project_name}/errors.log
StandardError    = append:/home/ubuntu/${project_name}/errors.log
WorkingDirectory = /home/ubuntu/${project_name}/
ExecStart      = /home/ubuntu/${project_name}/pocketbase serve

[Install]
WantedBy = multi-user.target
" | sudo tee /lib/systemd/system/${project_name}-pocketbase.service


sudo systemctl daemon-reload
sudo systemctl enable ${project_name}-pocketbase.service
sudo systemctl start ${project_name}-pocketbase

echo "========= adding caddy configuration ======="
# Add subdomain configuration to Caddyfile
caddy_config="
${project_name}.tigawanna.vip {
    request_body {
        max_size 10MB
    }
    reverse_proxy 127.0.0.1:${port} {
        transport http {
            read_timeout 360s
        }
        # Add these headers to forward client IP
        header_up X-Forwarded-For {remote_host}
        header_up X-Real-IP {remote_host}
    }
}
"

# Check if Caddyfile exists and add configuration
if [ -f "/etc/caddy/Caddyfile" ]; then
    echo "Adding ${project_name} subdomain configuration to Caddyfile..."
    echo "$caddy_config" | sudo tee -a /etc/caddy/Caddyfile
    echo "Reloading Caddy configuration..."
    sudo systemctl reload caddy
else
    echo "Warning: /etc/caddy/Caddyfile not found. Please add the following configuration manually:"
    echo "$caddy_config"
fi

echo "========= setup complete! ======="
echo "Project: ${project_name}"
echo "Port: ${port}"
echo "Subdomain: ${project_name}.tigawanna.vip"
echo "Service: ${project_name}-pocketbase.service"
