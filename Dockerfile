from ubuntu:20.04

# ALL VARIABLES 
ARG ANSIBLE_MAIN_FILE="./ansible.yml"
ARG ANSIBLE_SSH_FILE="./ansible/ssh_plays.yml"
ARG ANSIBLE_ZSH_FILE="./ansible/zsh_plays.yml"
ARG ANSIBLE_VSCODE_FILE="./ansible/vscode_plays.yml"
ARG ANSIBLE_VSCODE_SERVER_FOLDER="./.vscode-server"



WORKDIR /app

RUN apt-get update && \
    apt-get install -y ansible

COPY $ANSIBLE_MAIN_FILE $ANSIBLE_MAIN_FILE



# Install SSH with ansible
COPY $ANSIBLE_SSH_FILE $ANSIBLE_SSH_FILE

RUN ansible-playbook -t ssh $ANSIBLE_MAIN_FILE
EXPOSE 22



# Install ZSH and plugins
COPY $ANSIBLE_ZSH_FILE $ANSIBLE_ZSH_FILE

COPY ./.zshrc ./ 
RUN ansible-playbook -t zsh $ANSIBLE_MAIN_FILE


COPY . .
# Change the owner of the app folder (42420 is the user id of the cloud user)
RUN chown -R 42420:42420 /app

USER root

CMD ["./start.sh"]