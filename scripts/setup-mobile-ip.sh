#!/bin/bash
# Setup script for Flutter mobile app IP configuration

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Setting up Flutter Mobile App Config${NC}"
echo -e "${BLUE}========================================\n${NC}"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_ROOT/mobile/nurse_app/lib/config.dart"

# Detect local IP
detect_ip() {
    # Try multiple methods to find IP
    local ip=""
    
    # Method 1: hostname -I (Linux/WSL)
    if command -v hostname &> /dev/null; then
        ip=$(hostname -I | awk '{print $1}')
        if [ -n "$ip" ] && [ "$ip" != "127.0.0.1" ]; then
            echo "$ip"
            return 0
        fi
    fi
    
    # Method 2: ifconfig (macOS/Linux)
    if command -v ifconfig &> /dev/null; then
        ip=$(ifconfig | grep -E "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')
        if [ -n "$ip" ]; then
            echo "$ip"
            return 0
        fi
    fi
    
    # Method 3: ipconfig (Windows/WSL)
    if command -v ipconfig &> /dev/null; then
        ip=$(ipconfig | grep "IPv4 Address" | head -1 | awk -F': ' '{print $2}' | xargs)
        if [ -n "$ip" ]; then
            echo "$ip"
            return 0
        fi
    fi
    
    # Fallback
    echo "127.0.0.1"
}

IP=$(detect_ip)

if [ -z "$IP" ]; then
    echo -e "${RED}❌ Could not detect IP address${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Detected IP: $IP${NC}"

# Update config.dart
if [ -f "$CONFIG_FILE" ]; then
    # Replace the apiBaseUrl line
    sed -i "s|static const String apiBaseUrl = '.*:8000';|static const String apiBaseUrl = 'http://$IP:8000';|g" "$CONFIG_FILE"
    
    echo -e "${GREEN}✅ Updated config.dart with IP: $IP${NC}"
    echo -e "${BLUE}ℹ️  API Base URL: http://$IP:8000${NC}"
    
    # Show the updated line
    echo ""
    echo -e "${BLUE}Updated configuration:${NC}"
    grep "apiBaseUrl" "$CONFIG_FILE" | head -1
else
    echo -e "${RED}❌ config.dart not found at: $CONFIG_FILE${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Flutter mobile app configured successfully!${NC}"
echo -e "${YELLOW}Note: Hot reload might be needed in Flutter${NC}"
