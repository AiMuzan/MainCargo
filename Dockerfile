from ubuntu:20.04

# ALL VARIABLES 
ARG ANSIBLE_MAIN_FILE="./ansible.yml"
ARG ANSIBLE_VSCODE_SERVER_FOLDER="./.vscode-server"



WORKDIR /app

RUN apt-get update && \
    apt-get install -y ansible

COPY $ANSIBLE_MAIN_FILE $ANSIBLE_MAIN_FILE



# Install SSH with ansible
ARG ANSIBLE_SSH_FILE="./ansible/ssh_plays.yml"
COPY $ANSIBLE_SSH_FILE $ANSIBLE_SSH_FILE

RUN ansible-playbook -t ssh $ANSIBLE_MAIN_FILE
EXPOSE 22



# Install ZSH and plugins
ARG ANSIBLE_ZSH_FILE="./ansible/zsh_plays.yml"
COPY $ANSIBLE_ZSH_FILE $ANSIBLE_ZSH_FILE

COPY ./.zshrc ./ 
RUN ansible-playbook -t zsh $ANSIBLE_MAIN_FILE



# Install VSCODE Server
ARG ANSIBLE_VSCODE_FILE="./ansible/vscode_plays.yml"
COPY $ANSIBLE_VSCODE_FILE $ANSIBLE_VSCODE_FILE

COPY $ANSIBLE_VSCODE_SERVER_FOLDER $ANSIBLE_VSCODE_SERVER_FOLDER
RUN ansible-playbook -t vscode $ANSIBLE_MAIN_FILE
EXPOSE 8080



COPY . .

# Good owner for OVH 
RUN chown -R 42420:42420 /app
WORKDIR /workspace
WORKDIR /muzan
RUN chown -R 42420:42420 /workspace

CMD ["./start.sh"]