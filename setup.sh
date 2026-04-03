#!/bin/bash

set -e

# ======================
# Guide function
# ======================
show_guide() {
    cat << 'EOF'
=============================================================
System Setup Script Guide
=============================================================

Usage:
  ./setup.sh [options...]

Options:
  guide              Show this guide
  delete             Delete this script and related files
  
  [number]           Install specific Java version (e.g., 21, 17, 11)
  javaless           Skip Java installation
  
  dockerless         Skip Docker installation (automatically skips compose)
  composeless        Skip Docker Compose installation
  
  updateless         Skip system update
  
  default            Default setup (Java 21 + Docker + Docker Compose)

Examples:
  ./setup.sh                          # Default setup
  ./setup.sh 17                       # Java 17 + Docker + Docker Compose
  ./setup.sh javaless                 # Docker only (no Java)
  ./setup.sh dockerless               # Java only (no Docker)
  ./setup.sh composeless              # Java + Docker (no Compose)
  ./setup.sh javaless dockerless      # System update only
  ./setup.sh 11 composeless           # Java 11 + Docker (no Compose)
  ./setup.sh updateless dockerless    # Java only (no update, no Docker)
  ./setup.sh delete                   # Clean up script files

Notes:
  - Options order does not matter: dockerless, javaless, composeless, updateless
  - dockerless automatically implies composeless
  - Java version must be a number (e.g., 21, 17, 11, 8)
  - delete: Removes script files after setup completion

=============================================================
EOF
    exit 0
}

# ======================
# Delete function
# ======================
delete_script() {
    echo "=========================================="
    echo "Cleaning up setup script files..."
    echo "=========================================="
    
    CURRENT_DIR=$(basename "$PWD")
    
    if [[ "$CURRENT_DIR" == "setup.sh" ]]; then
        # If directory name is "setup.sh", delete entire directory
        echo "[INFO] Current directory is 'setup.sh'"
        echo "[INFO] Moving up and deleting entire directory..."
        PARENT_DIR=$(dirname "$PWD")
        cd "$PARENT_DIR"
        rm -rf "setup.sh"
        echo "[DONE] Directory 'setup.sh' has been removed!"
    else
        # Otherwise, delete only script-related files
        echo "[INFO] Deleting script files from current directory..."
        rm -rf .git
        rm -f README.md
        rm -f koREADME.md
        rm -f setup.sh
        echo "[DONE] Script files have been removed!"
        echo "       (.git, README.md, koREADME.md, setup.sh)"
    fi
    
    exit 0
}

# ======================
# Parse arguments
# ======================
JAVA_VERSION=21
INSTALL_JAVA=true
INSTALL_DOCKER=true
INSTALL_COMPOSE=true
SYSTEM_UPDATE=true
CURRENT_USER=$(whoami)

# Check for guide command
if [[ "$1" == "guide" ]]; then
    show_guide
fi

# Check for delete command
if [[ "$1" == "delete" ]]; then
    delete_script
fi

# If no arguments or default, use default values
if [[ $# -eq 0 ]] || [[ "$1" == "default" ]]; then
    : # Keep defaults
else
    # Parse all arguments
    for arg in "$@"; do
        case "$arg" in
            javaless)
                INSTALL_JAVA=false
                ;;
            dockerless)
                INSTALL_DOCKER=false
                INSTALL_COMPOSE=false  # dockerless automatically implies composeless
                ;;
            composeless)
                INSTALL_COMPOSE=false
                ;;
            updateless)
                SYSTEM_UPDATE=false
                ;;
            default)
                : # Keep defaults
                ;;
            [0-9]*)
                # If number, treat as Java version
                JAVA_VERSION="$arg"
                INSTALL_JAVA=true
                ;;
            *)
                echo "[ERROR] Unknown option: $arg"
                echo "Run './setup.sh guide' to see available options."
                exit 1
                ;;
        esac
    done
fi

# Warning if both javaless and dockerless
if [[ "$INSTALL_JAVA" == "false" ]] && [[ "$INSTALL_DOCKER" == "false" ]]; then
    echo "[WARNING] Skipping both Java and Docker installation."
    echo "          Only system update will be performed. Why use this script? lol"
    echo ""
fi

# ======================
# Configuration Summary
# ======================
echo "=========================================="
echo "Setup Configuration"
echo "=========================================="
echo "System Update: $([[ "$SYSTEM_UPDATE" == "true" ]] && echo "[O] Yes" || echo "[X] Skip")"
echo "Java Install: $([[ "$INSTALL_JAVA" == "true" ]] && echo "[O] OpenJDK $JAVA_VERSION" || echo "[X] Skip")"
echo "Docker Install: $([[ "$INSTALL_DOCKER" == "true" ]] && echo "[O] Yes" || echo "[X] Skip")"
echo "Docker Compose Install: $([[ "$INSTALL_COMPOSE" == "true" ]] && echo "[O] Yes" || echo "[X] Skip")"
echo "=========================================="
echo ""

# ======================
# System Update
# ======================
if [[ "$SYSTEM_UPDATE" == "true" ]]; then
    echo ">>> Updating system..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
    echo ""
else
    echo ">>> Skipping system update"
    echo ""
fi

# ======================
# Install Java
# ======================
if [[ "$INSTALL_JAVA" == "true" ]]; then
    echo ">>> Installing OpenJDK ${JAVA_VERSION}..."
    sudo apt-get install -y openjdk-${JAVA_VERSION}-jdk
    java -version
    echo ""
else
    echo ">>> Skipping Java installation"
    echo ""
fi

# ======================
# Install Docker
# ======================
if [[ "$INSTALL_DOCKER" == "true" ]]; then
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

    # Add user to docker group
    sudo usermod -aG docker "$CURRENT_USER"
    sudo usermod -aG docker ubuntu
    echo ""
else
    echo ">>> Skipping Docker installation"
    echo ""
fi

# ======================
# Install Docker Compose (plugin)
# ======================
if [[ "$INSTALL_COMPOSE" == "true" ]]; then
    echo ">>> Installing docker compose..."
    sudo apt-get install -y docker-compose-plugin
    echo ""
else
    echo ">>> Skipping Docker Compose installation"
    echo ""
fi

# ======================
# Check versions
# ======================
echo "=========================================="
echo ">>> Installation Complete!"
echo "=========================================="

if [[ "$INSTALL_JAVA" == "true" ]]; then
    echo "Java version:"
    java -version
    echo ""
fi

if [[ "$INSTALL_DOCKER" == "true" ]]; then
    echo "Docker version:"
    docker --version
    echo ""
fi

if [[ "$INSTALL_COMPOSE" == "true" ]]; then
    echo "Docker Compose version:"
    docker compose version
    echo ""
fi

echo "=========================================="
echo "[DONE] All tasks completed!"
echo "=========================================="