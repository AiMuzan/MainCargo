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


# Launch Koyha SS
source /app/src/venv/bin/activate
python3.10 src/kohya_ss/setup/setup_linux.py --platform-requirements-file=requirements_runpod.txt --show_stdout --no_run_accelerate
src/kohya_ss/gui.sh --share --headless --listen 3000


# The case when the principal process is not a shell
echo "The main process is not a shell... launch infinite loop to keep the container running"
sleep infinity