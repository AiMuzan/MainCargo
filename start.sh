#!/bin/bash
set -e

# Start SSH in background
service ssh start

# Start code-server in background
code-server ./src &

# Install all models for ComfyUI
./src/models.sh &

# Start ComfyUI 
source /app/src/venv/bin/activate
python3 /app/src/ComfyUI/main.py --listen 0.0.0.0 --port 3000