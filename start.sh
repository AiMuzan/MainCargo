#!/bin/bash
set -e

# Get information about the container
echo "Container user : $(whoami)"
echo "Container permissions :"
ls -lash /app

# Start SSH in background
if [ "${ENABLE_SSH:-false}" = "true" ]; then
    echo "You choice ENABLE_SSH=true, starting SSH server..."
    service ssh start
else
    echo "You choice ENABLE_SSH=false, skip starting SSH server"
fi

# Start code-server in background
if [ "${ENABLE_CODESERVER:-false}" = "true" ]; then
    echo "You choice ENABLE_CODESERVER=true, starting code-server..."
    code-server ./src &
else
    echo "You choice ENABLE_CODESERVER=false, skip starting code-server"
fi

# Install all models for ComfyUI
python3 /app/src/models.py &

# Start ComfyUI 
source /app/src/venv/bin/activate
python3 /app/src/ComfyUI/main.py --listen 0.0.0.0 --port 3000