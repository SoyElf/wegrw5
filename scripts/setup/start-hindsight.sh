#!/bin/bash
# Start Hindsight with Podman
# Usage: ./hindsight-start.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if .env.hindsight exists
if [ ! -f .env.hindsight ]; then
    echo -e "${RED}Error: .env.hindsight not found${NC}"
    echo "Please create .env.hindsight from .env.hindsight.example and add your API key"
    exit 1
fi

# Load environment variables
set -a
source .env.hindsight
set +a

# Verify required variables
if [ -z "$HINDSIGHT_API_LLM_API_KEY" ]; then
    echo -e "${RED}Error: HINDSIGHT_API_LLM_API_KEY not set in .env.hindsight${NC}"
    exit 1
fi

# Create .hindsight directory if it doesn't exist
mkdir -p .hindsight

echo -e "${GREEN}Starting Hindsight with Podman...${NC}"
echo "API Provider: ${HINDSIGHT_API_LLM_PROVIDER:-gemini}"
echo "Model: ${HINDSIGHT_API_LLM_MODEL:-gemini-2.5-flash}"
echo "Database: $(pwd)/.hindsight"
echo ""

# Run Hindsight
podman run --rm -it --pull always \
  --userns=keep-id \
  -p 8888:8888 -p 9999:9999 \
  -e HINDSIGHT_API_LLM_API_KEY \
  -e HINDSIGHT_API_LLM_PROVIDER \
  -e HINDSIGHT_API_LLM_MODEL \
  -v $(pwd)/.hindsight:/home/hindsight/.pg0 \
  ghcr.io/vectorize-io/hindsight:latest
