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

PATH_TO_KOHYA_SS="/app/src/kohya_ss"
PATH_VENV="${PATH_TO_KOHYA_SS}/venv"
PATH_VENV_ACTIVATE="${PATH_VENV}/bin/activate"

# Launch Koyha SS
if [ -e $PATH_VENV_ACTIVATE ]; then
    echo "Virtual environment detected, activating it..."

    source $PATH_VENV_ACTIVATE
    $PATH_TO_KOHYA_SS/gui.sh --share --headless --listen=0.0.0.0 --server_port=3000
else
    # The case when the principal process is not a shell
    echo "No virtual environment detected, skipping activation..."
    
    echo "The main process is not a shell... launch infinite loop to keep the container running"
    sleep infinity
fi