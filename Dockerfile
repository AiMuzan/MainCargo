FROM nvidia/cuda:12.4.0-base-ubuntu22.04

# ALL VARIABLES 
ARG ANSIBLE_MAIN_FILE="./ansible.yml"

USER root

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


# Install NVIM and plugins
ARG ANSIBLE_NVIM_FILE="./ansible/nvim_plays.yml"
COPY $ANSIBLE_NVIM_FILE $ANSIBLE_NVIM_FILE

COPY ./nvim ./nvim
RUN ansible-playbook -t nvim $ANSIBLE_MAIN_FILE
# RUN nvim --headless +PackerSync +qa

####  -------------------------------  ####
# Install KohyaSS
####  -------------------------------  ####
COPY ./.git ./.git
COPY ./.gitmodules ./.gitmodules

ARG ANSIBLE_KOHYASS_FILE="./src/ansible/install_kohyass_plays.yml"
COPY $ANSIBLE_KOHYASS_FILE $ANSIBLE_KOHYASS_FILE

RUN ansible-playbook -t kohyass $ANSIBLE_MAIN_FILE
EXPOSE 3000

COPY . .

CMD ["./start.sh"]