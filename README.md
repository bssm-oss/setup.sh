# System Setup Script

A flexible bash script for automated installation of Java, Docker, and Docker Compose on Ubuntu/Debian systems.

[한국어 문서](koREADME.md)

## Features

- **Java Installation**: Install any OpenJDK version (8, 17, 21, 25, etc.)
- **Docker Installation**: Install Docker CE with proper user permissions
- **Docker Compose**: Install Docker Compose plugin
- **Flexible Options**: Skip any component with simple flags
- **Order-Independent**: Options can be specified in any order

## Before using

On Debian/Ubuntu systems, ensure git is installed before cloning or running scripts from a repository.

```bash
sudo apt update && sudo apt install -y git
```

Clone this repository (replace with the actual repo URL and directory name):

```bash
git clone https://github.com/HyunwooKiim/setup.sh
cd setup.sh
```

## Quick Start

```bash
# Make script executable
chmod +x setup.sh

# Run with default settings (Java 21 + Docker + Docker Compose)
./setup.sh

# Show guide
./setup.sh guide
```

## Usage

```bash
./setup.sh [options...]
```

### Options

| Option | Description |
|--------|-------------|
| `guide` | Show detailed usage guide |
| `delete` | Clean up script and related files |
| `[number]` | Install specific Java version (e.g., 21, 17, 11, 8) |
| `javaless` | Skip Java installation |
| `dockerless` | Skip Docker installation (automatically skips compose) |
| `composeless` | Skip Docker Compose installation |
| `updateless` | Skip system update |
| `default` | Use default configuration |

### Examples

```bash
# Install everything with defaults (Java 21 + Docker + Docker Compose)
./setup.sh

# Install Java 17 with Docker and Docker Compose
./setup.sh 17

# Install only Docker (no Java)
./setup.sh javaless

# Install only Java 21 (no Docker)
./setup.sh dockerless

# Install Java and Docker without Compose
./setup.sh composeless

# Install Java 11 and Docker without Compose
./setup.sh 11 composeless

# Skip system update, install only Java
./setup.sh updateless dockerless

# Multiple options (order doesn't matter)
./setup.sh javaless dockerless updateless

# Clean up script files after installation
./setup.sh delete
```

## Delete Function

The `delete` option cleans up the script and related files after installation:

- **If directory name is `setup.sh`**: 
  - Moves to parent directory and deletes the entire `setup.sh` directory
  
- **If directory name is something else**: 
  - Deletes only: `.git`, `README.md`, `koREADME.md`, and `setup.sh`

```bash
# After successful installation, clean up
./setup.sh delete
```

## Important Notes

- **Option Order**: Options can be specified in any order
  - `./setup.sh dockerless javaless` = `./setup.sh javaless dockerless`

- **Automatic Dependencies**: 
  - Using `dockerless` automatically implies `composeless` (Docker Compose requires Docker)

- **System Update**: 
  - System update (`apt-get update && apt-get upgrade`) runs by default
  - Use `updateless` to skip it

- **Java Version**: 
  - Only numbers are accepted for Java version
  - Default is Java 21 (OpenJDK)
  - Common versions: 21, 17, 11, 8

- **Docker Permissions**: 
  - Script automatically adds the `ubuntu` user to the `docker` group
  - You may need to log out and back in for group changes to take effect

## Requirements

- Ubuntu/Debian-based Linux distribution
- `sudo` privileges
- Internet connection

## What Gets Installed

### Default Configuration (`./setup.sh`)

1. **System Update**
   - `apt-get update -y`
   - `apt-get upgrade -y`

2. **Java (OpenJDK 21)**
   - `openjdk-21-jdk`

3. **Docker**
   - Docker CE
   - Docker CLI
   - containerd.io
   - User added to docker group

4. **Docker Compose**
   - docker-compose-plugin

## License

This is a utility script. Use at your own risk.

## Contributing

Feel free to submit issues or pull requests.
