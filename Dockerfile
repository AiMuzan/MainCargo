from ubuntu:20.04

WORKDIR /app

RUN apt-get update && \
    apt-get install -y ansible

COPY ./ansible.yml ./
COPY ./ansible ./ansible

# Install SSH with ansible
RUN ansible-playbook -t ssh ./ansible.yml
EXPOSE 22


COPY . .

CMD ["./start.sh"]