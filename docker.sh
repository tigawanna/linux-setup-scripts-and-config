#!/bin/bash



# # remove existing docker instalations
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; 
# do sudo apt-get remove $pkg; 
# done
# # update all
# sudo apt-get update

# dekete existing source docker list
# sudo rm -rf /etc/apt/sources.list.d/docker.list 


# Update package index
# sudo apt-get update





# Install prerequisites
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
# We're using $(. /etc/os-release && echo "$UBUNTU_CODENAME") to get the correct Ubuntu codename
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
sudo apt-get update

echo "Docker repository has been added. Now attempting to install Docker..."

# Install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker installation complete. You may need to log out and back in for changes to take effect."
