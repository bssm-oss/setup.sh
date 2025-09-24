#!/bin/bash

set -e

echo ">>> Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

# ======================
# Install Java 21 (OpenJDK)
# ======================
echo ">>> Installing OpenJDK 21..."
sudo apt-get install -y openjdk-21-jdk
java -version

# ======================
# Install Docker
# ======================
echo ">>> Installing Docker..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg

# Docker GPG key 추가
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Docker repo 추가
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker 설치
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker 그룹 권한 (ubuntu 유저도 docker 사용 가능)
sudo usermod -aG docker ubuntu

# ======================
# Install Docker Compose (plugin)
# ======================
echo ">>> Installing docker compose..."
sudo apt-get install -y docker-compose-plugin

# ======================
# Check versions
# ======================
echo ">>> Installation completed!"
java -version
docker --version
docker compose version