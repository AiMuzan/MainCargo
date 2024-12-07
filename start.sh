#!/bin/bash
set -e


# Start SSH in background
if [ "${ENABLE_SSH:-true}" = "true" ]; then
    service ssh start
fi

# Start code-server in background
if [ "${ENABLE_CODESERVER:-true}" = "true" ]; then
    code-server ./src &
fi

# Install all models for ComfyUI
python3 /app/src/models.py &

# Start ComfyUI 
source /app/src/venv/bin/activate
python3 /app/src/ComfyUI/main.py --listen 0.0.0.0 --port 3000