#!/bin/bash

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
export PURPLE='\033[0;35m'
NC='\033[0m'

print_section() {
    local message=$1
    echo -e "\n${PURPLE}========================================${NC}"
    echo -e "${PURPLE} $message${NC}"
    echo -e "${PURPLE}========================================${NC}\n"
}

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}
