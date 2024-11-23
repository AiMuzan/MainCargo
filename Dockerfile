from ubuntu:20.04

WORKDIR /app
COPY . .

CMD ["./start.sh"]