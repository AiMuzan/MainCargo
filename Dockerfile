from ubuntu:25.04

# ALL VARIABLES 
ARG ANSIBLE_MAIN_FILE="./ansible.yml"
ARG ANSIBLE_SSH_FILE="./ansible/ssh_plays.yml"
ARG ANSIBLE_ZSH_FILE="./ansible/zsh_plays.yml"
ARG ANSIBLE_NVIM_FILE="./ansible/nvim_plays.yml"

USER root

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


# Install NVIM and plugins
COPY $ANSIBLE_NVIM_FILE $ANSIBLE_NVIM_FILE

COPY ./nvim ./nvim
RUN ansible-playbook -t nvim $ANSIBLE_MAIN_FILE



COPY . .

CMD ["./start.sh"]