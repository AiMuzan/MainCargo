from ubuntu:24.04

####  -------------------------------  ####
# ALL VARIABLES
####  -------------------------------  ####

# VARIABLE FOR MAINCARGO
ARG ANSIBLE_MAIN_FILE="./ansible.yml"
ARG ANSIBLE_SSH_FILE="./ansible/ssh_plays.yml"
ARG ANSIBLE_ZSH_FILE="./ansible/zsh_plays.yml"
ARG ANSIBLE_VSCODE_FILE="./ansible/vscode_plays.yml"
ARG ANSIBLE_VSCODE_SERVER_FOLDER="./.vscode-server"

# VARIABLE FOR COMFYUI
ARG ANSIBLE_COMFYUI_FILE="./src/ansible/install_comfyui_plays.yml"


WORKDIR /app

RUN apt-get update && \
    apt-get install -y ansible

# Generate locale settings in en_US.UTF-8
RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8

    
COPY $ANSIBLE_MAIN_FILE $ANSIBLE_MAIN_FILE


####  -------------------------------  ####
# INSTALL COMMON SETUP FROM MAINCARGO
####  -------------------------------  ####

# Install SSH with ansible
COPY $ANSIBLE_SSH_FILE $ANSIBLE_SSH_FILE

RUN ansible-playbook -t ssh $ANSIBLE_MAIN_FILE
EXPOSE 22



# Install ZSH and plugins
COPY $ANSIBLE_ZSH_FILE $ANSIBLE_ZSH_FILE

COPY ./.zshrc ./ 
RUN ansible-playbook -t zsh $ANSIBLE_MAIN_FILE



# Install VSCODE Server
COPY $ANSIBLE_VSCODE_FILE $ANSIBLE_VSCODE_FILE

COPY $ANSIBLE_VSCODE_SERVER_FOLDER $ANSIBLE_VSCODE_SERVER_FOLDER
RUN ansible-playbook -t vscode $ANSIBLE_MAIN_FILE
EXPOSE 8080




####  -------------------------------  ####
# Install ComfyUI
####  -------------------------------  ####
COPY $ANSIBLE_COMFYUI_FILE $ANSIBLE_COMFYUI_FILE

COPY ./src/ComfyUI/requirements.txt ./src/ComfyUI/requirements.txt
RUN ansible-playbook -t install_comfyui $ANSIBLE_MAIN_FILE
COPY ./src/ComfyUI/ ./src/ComfyUI/
EXPOSE 3000

# Need rootpermission for OVH ( not for runpods )
USER root

COPY . . 
CMD ["./start.sh"]