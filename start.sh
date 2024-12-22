#!/bin/bash
set -e

# Get information about the container and the user
echo "User: $(whoami)"
echo "Home: $HOME"
echo "Shell: $SHELL"
echo "PWD: $PWD"

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

# Install all models for ComfyUI
python3 /app/src/models.py &

# Start ComfyUI 
source /app/src/venv/bin/activate
python3 /app/src/ComfyUI/main.py --listen 0.0.0.0 --port 3000